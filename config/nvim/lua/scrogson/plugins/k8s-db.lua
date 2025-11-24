return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    'tpope/vim-dadbod',
    'nvim-telescope/telescope.nvim',
    'nvim-lua/plenary.nvim',
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
    'K8sDB'
  },
  init = function()
    -- DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1

    -- Window and tree styling
    vim.g.db_ui_winwidth = 40
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_show_help = 0  -- Hide the help text at top
    vim.g.db_ui_use_nvim_notify = 1  -- Use nvim-notify for messages

    -- Set up autocmd for DBUI buffer to improve styling
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dbui',
      callback = function()
        vim.opt_local.conceallevel = 0
        vim.opt_local.signcolumn = 'no'
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.cursorline = true
        vim.opt_local.shiftwidth = 2  -- Control tree indentation
      end,
    })
  end,
  config = function()
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    -- Track active port-forward jobs
    local active_forwards = {}

    -- Cleanup function to stop all port-forwards
    local function cleanup_port_forwards()
      for _, job_id in pairs(active_forwards) do
        vim.fn.jobstop(job_id)
      end
      active_forwards = {}
    end

    -- Stop port-forwards on vim exit
    vim.api.nvim_create_autocmd('VimLeavePre', {
      callback = cleanup_port_forwards,
    })

    -- Patterns to detect database pods
    local db_patterns = {
      postgres = { 'postgres', 'postgresql', 'timescale', 'crunchy' },
      mysql = { 'mysql', 'mariadb', 'percona' },
      mongo = { 'mongo' },
    }

    -- Get database pods from Kubernetes
    local function get_database_pods(namespace, db_type, show_all)
      local cmd = namespace and
        string.format('kubectl get pods -n %s -o json', namespace) or
        'kubectl get pods --all-namespaces -o json'

      local result = vim.fn.system(cmd)
      if vim.v.shell_error ~= 0 then
        vim.notify('Failed to get pods: ' .. result, vim.log.levels.ERROR)
        return {}
      end

      local ok, data = pcall(vim.json.decode, result)
      if not ok then
        vim.notify('Failed to parse kubectl output', vim.log.levels.ERROR)
        return {}
      end

      local pods = {}
      local patterns = db_type and db_patterns[db_type] or db_patterns.postgres

      for _, pod in ipairs(data.items or {}) do
        local pod_name = pod.metadata.name
        local pod_namespace = pod.metadata.namespace

        if pod.status.phase ~= 'Running' then
          goto continue
        end

        local is_db = false
        local db_info = ''

        if show_all then
          -- Show all running pods
          is_db = true
          db_info = ' (manual selection)'
        else
          -- Check container images
          for _, container in ipairs(pod.spec.containers or {}) do
            local image_lower = container.image:lower()
            for _, pattern in ipairs(patterns) do
              if string.match(image_lower, pattern) then
                is_db = true
                db_info = string.format(' [%s]', container.image:match('([^/]+)$') or container.image)
                break
              end
            end
            if is_db then break end
          end

          -- Check labels
          if not is_db and pod.metadata.labels then
            for key, value in pairs(pod.metadata.labels) do
              local label_check = (key .. '=' .. value):lower()
              for _, pattern in ipairs(patterns) do
                if string.match(label_check, pattern) then
                  is_db = true
                  db_info = string.format(' [label: %s=%s]', key, value)
                  break
                end
              end
              if is_db then break end
            end
          end
        end

        if is_db then
          table.insert(pods, {
            name = pod_name,
            namespace = pod_namespace,
            display = string.format('[%s] %s%s', pod_namespace, pod_name, db_info),
          })
        end

        ::continue::
      end

      return pods
    end

    -- Setup port forward and connect to database
    local function connect_to_pod(pod, opts)
      opts = opts or {}
      local port = opts.port or 5432
      local local_port = opts.local_port or 5432
      local db_name = opts.db_name or 'postgres'
      local db_user = opts.db_user or 'postgres'
      local db_password = opts.db_password or ''

      -- Find an available local port if specified port is in use
      local function find_available_port(start_port)
        for p = start_port, start_port + 100 do
          local handle = io.popen(string.format('lsof -i :%d', p))
          if handle then
            local result = handle:read('*a')
            handle:close()
            if result == '' then
              return p
            end
          end
        end
        return start_port
      end

      local_port = find_available_port(local_port)

      -- Stop existing port-forward for this pod if any
      local forward_key = string.format('%s/%s', pod.namespace, pod.name)
      if active_forwards[forward_key] then
        vim.fn.jobstop(active_forwards[forward_key])
      end

      -- Start port-forward
      local cmd = string.format(
        'kubectl port-forward -n %s %s %d:%d',
        pod.namespace,
        pod.name,
        local_port,
        port
      )

      vim.notify(string.format('Starting port-forward: %s', cmd), vim.log.levels.INFO)

      local job_id = vim.fn.jobstart(cmd, {
        on_stdout = function(_, data)
          if data and #data > 0 then
            for _, line in ipairs(data) do
              if line ~= '' then
                vim.notify('Port-forward: ' .. line, vim.log.levels.INFO)
              end
            end
          end
        end,
        on_stderr = function(_, data)
          if data and #data > 0 then
            for _, line in ipairs(data) do
              if line ~= '' and not string.match(line, '^Forwarding from') then
                vim.notify('Port-forward error: ' .. line, vim.log.levels.WARN)
              end
            end
          end
        end,
        on_exit = function(_, exit_code)
          active_forwards[forward_key] = nil
          if exit_code ~= 0 then
            vim.notify(
              string.format('Port-forward exited with code %d', exit_code),
              vim.log.levels.WARN
            )
          end
        end,
      })

      active_forwards[forward_key] = job_id

      -- Wait a moment for port-forward to establish
      vim.defer_fn(function()
        -- Build connection URL
        local password_part = db_password ~= '' and (':' .. db_password) or ''
        local connection_url = string.format(
          'postgresql://%s%s@localhost:%d/%s',
          db_user,
          password_part,
          local_port,
          db_name
        )

        -- Add connection to vim-dadbod
        local connection_name = string.format('k8s_%s_%s', pod.namespace, pod.name)
        vim.g['db#' .. connection_name] = connection_url

        -- Try to open DBUI and navigate to the connection
        vim.cmd('DBUI')

        vim.notify(
          string.format('Connected to %s (localhost:%d)', pod.name, local_port),
          vim.log.levels.INFO
        )
      end, 2000)
    end

    -- Telescope picker for pods
    local function select_k8s_db(opts)
      opts = opts or {}
      local namespace = opts.namespace
      local db_type = opts.db_type or 'postgres'
      local show_all = opts.show_all or false

      local pods = get_database_pods(namespace, db_type, show_all)

      if #pods == 0 then
        -- No database pods found, offer to show all pods
        local choice = vim.fn.confirm(
          'No database pods found. Would you like to:',
          "&Show all pods\n&Cancel\n&Enter custom pattern",
          2
        )

        if choice == 1 then
          -- Show all pods
          return select_k8s_db(vim.tbl_extend('force', opts, { show_all = true }))
        elseif choice == 3 then
          -- Let user enter custom search pattern
          local pattern = vim.fn.input('Enter search pattern (pod name): ')
          if pattern ~= '' then
            -- Get all pods and filter by user pattern
            local all_pods = get_database_pods(namespace, db_type, true)
            pods = vim.tbl_filter(function(pod)
              return string.match(pod.name:lower(), pattern:lower())
            end, all_pods)

            if #pods == 0 then
              vim.notify('No pods matching pattern: ' .. pattern, vim.log.levels.WARN)
              return
            end
          else
            return
          end
        else
          return
        end
      end

      local title = show_all and 'All Kubernetes Pods' or 'Kubernetes Database Pods'

      pickers.new(opts, {
        prompt_title = title,
        finder = finders.new_table({
          results = pods,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.display,
              ordinal = entry.display,
            }
          end,
        }),
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            if selection then
              -- Prompt for connection details
              local db_name = vim.fn.input('Database name [postgres]: ')
              if db_name == '' then db_name = 'postgres' end

              local db_user = vim.fn.input('Username [postgres]: ')
              if db_user == '' then db_user = 'postgres' end

              local db_password = vim.fn.inputsecret('Password (optional): ')

              local port = vim.fn.input('Remote port [5432]: ')
              port = port ~= '' and tonumber(port) or 5432

              local local_port = vim.fn.input('Local port [5432]: ')
              local_port = local_port ~= '' and tonumber(local_port) or 5432

              connect_to_pod(selection.value, {
                db_name = db_name,
                db_user = db_user,
                db_password = db_password,
                port = port,
                local_port = local_port,
              })
            end
          end)
          return true
        end,
      }):find()
    end

    -- Create user commands
    vim.api.nvim_create_user_command('K8sDB', function(opts)
      select_k8s_db({ namespace = opts.args ~= '' and opts.args or nil })
    end, {
      nargs = '?',
      desc = 'Connect to Kubernetes PostgreSQL database',
    })

    -- Optional: Add a keybinding
    vim.keymap.set('n', '<leader>dk', function()
      select_k8s_db()
    end, { desc = '[D]atabase [K]ubernetes connect' })
  end,
}

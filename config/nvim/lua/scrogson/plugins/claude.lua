return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = function()
    require('claudecode').setup {
      -- Add terminal-specific keymappings
      on_attach = function(bufnr)
        vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { buffer = bufnr, desc = 'Exit Claude terminal and move left' })
      end,
    }

    -- Also set up an autocmd for Claude terminals
    vim.api.nvim_create_autocmd('TermOpen', {
      pattern = '*claude*',
      callback = function()
        vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { buffer = 0, desc = 'Exit Claude terminal and move left' })
        vim.keymap.set('t', '<C-,>', '<cmd>hide<cr>', { buffer = 0, desc = 'Toggle Claude' })
        vim.keymap.set('t', '<C-l>', '<Nop>', { buffer = 0, desc = 'Disable Ctrl+L in Claude terminal' })
      end,
    })
  end,
  keys = {
    {
      '<C-,>',
      function()
        -- Check if we're in a Claude terminal
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname:match 'claude' and vim.bo.buftype == 'terminal' then
          -- Hide the terminal window instead of closing it
          vim.cmd 'hide'
        else
          -- Check if Claude terminal already exists
          local claude_buf = nil
          local claude_win = nil

          -- First check if Claude terminal is already visible
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            local name = vim.api.nvim_buf_get_name(buf)
            local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
            if buftype == 'terminal' and name:match 'claude' then
              claude_win = win
              claude_buf = buf
              break
            end
          end

          if claude_win then
            -- Claude terminal is already visible, just focus it
            vim.api.nvim_set_current_win(claude_win)
          else
            -- Check if Claude terminal exists but is hidden
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) then
                local name = vim.api.nvim_buf_get_name(buf)
                local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
                if buftype == 'terminal' and name:match 'claude' then
                  claude_buf = buf
                  break
                end
              end
            end

            if claude_buf then
              -- Show existing Claude terminal in a split on the far right
              vim.cmd('botright vsplit | buffer ' .. claude_buf)
              -- Resize to 30% of window width
              vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.3))
            else
              -- Start new Claude session
              vim.cmd 'ClaudeCode'
            end
          end
        end
      end,
      desc = 'Toggle Claude',
    },
    {
      '<leader>=',
      function()
        -- Find Claude window
        local claude_win = nil
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local name = vim.api.nvim_buf_get_name(buf)
          local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
          if buftype == 'terminal' and name:match 'claude' then
            claude_win = win
            break
          end
        end

        if claude_win then
          -- Focus the Claude window and resize to 30%
          vim.api.nvim_set_current_win(claude_win)
          vim.cmd('vertical resize ' .. math.floor(vim.o.columns * 0.3))
        else
          vim.notify('Claude terminal not found', vim.log.levels.WARN)
        end
      end,
      desc = 'Resize Claude to 30%',
    },
    {
      '<leader>+',
      function()
        -- Find Claude window
        local claude_win = nil
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local name = vim.api.nvim_buf_get_name(buf)
          local buftype = vim.api.nvim_buf_get_option(buf, 'buftype')
          if buftype == 'terminal' and name:match 'claude' then
            claude_win = win
            break
          end
        end

        if claude_win then
          -- Focus the Claude window and maximize it
          vim.api.nvim_set_current_win(claude_win)
          vim.cmd 'vertical resize 999'
        else
          vim.notify('Claude terminal not found', vim.log.levels.WARN)
        end
      end,
      desc = 'Maximize Claude',
    },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<D-l>', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    {
      '<D-l>',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil' },
    },
    -- Diff management
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    -- Window navigation
    { '<C-h>', '<C-\\><C-n><C-w>h', mode = 't', desc = 'Move to left window from Claude terminal' },
  },
}

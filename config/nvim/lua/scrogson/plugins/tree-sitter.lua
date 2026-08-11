-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
--
-- This targets the `main` branch rewrite: nvim-treesitter only installs
-- parsers and ships queries now. Highlighting/indent/folds come from Neovim
-- itself and are turned on per-buffer in the FileType autocommand below.
local ensure_installed = {
  'lua',
  'elixir',
  'heex',
  'rust',
  'tsx',
  'javascript',
  'typescript',
  'vimdoc',
  'vim',
  'bash',
  'fish',
  'html',
  'markdown',
  'markdown_inline',
  'query',
}

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    -- The rewrite does not support lazy-loading.
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').setup()

      require('nvim-treesitter').install(ensure_installed)

      vim.treesitter.language.register('markdown', 'octo')

      -- `get_available()` runs a `User TSUpdate` autocmd, so cache it rather
      -- than paying for it on every FileType.
      local available
      local function is_available(lang)
        if not available then
          available = {}
          for _, l in ipairs(require('nvim-treesitter').get_available()) do
            available[l] = true
          end
        end
        return available[lang] == true
      end

      local function enable(buf, lang)
        -- `language.add` returns false for a parser that isn't installed.
        -- Plugins with synthetic filetypes (noice, nui popups, ...) land here,
        -- since `get_lang` falls back to the filetype name itself.
        if not vim.api.nvim_buf_is_valid(buf) or not vim.treesitter.language.add(lang) then
          return
        end

        vim.treesitter.start(buf, lang)

        if vim.treesitter.query.get(lang, 'indents') then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        if vim.treesitter.query.get(lang, 'folds') and buf == vim.api.nvim_get_current_buf() then
          vim.wo[0][0].foldmethod = 'expr'
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('scrogson_treesitter', { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
          if not lang then
            return
          end

          -- Install on demand for filetypes not in `ensure_installed`, then
          -- start once the parser has landed.
          if not vim.treesitter.language.add(lang) then
            if is_available(lang) then
              require('nvim-treesitter').install(lang):await(function()
                vim.schedule(function()
                  enable(args.buf, lang)
                end)
              end)
            end
            return
          end

          enable(args.buf, lang)
        end,
      })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-treesitter-textobjects').setup {
        select = {
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        },
        move = {
          set_jumps = true, -- whether to set jumps in the jumplist
        },
      }

      local select = require 'nvim-treesitter-textobjects.select'
      local move = require 'nvim-treesitter-textobjects.move'
      local swap = require 'nvim-treesitter-textobjects.swap'

      -- You can use the capture groups defined in textobjects.scm
      local textobjects = {
        aa = '@parameter.outer',
        ia = '@parameter.inner',
        af = '@function.outer',
        ['if'] = '@function.inner',
        ac = '@class.outer',
        ic = '@class.inner',
      }
      for lhs, query in pairs(textobjects) do
        vim.keymap.set({ 'x', 'o' }, lhs, function()
          select.select_textobject(query, 'textobjects')
        end, { desc = 'Select ' .. query })
      end

      local moves = {
        [']m'] = { move.goto_next_start, '@function.outer' },
        [']]'] = { move.goto_next_start, '@class.outer' },
        [']M'] = { move.goto_next_end, '@function.outer' },
        [']['] = { move.goto_next_end, '@class.outer' },
        ['[m'] = { move.goto_previous_start, '@function.outer' },
        ['[['] = { move.goto_previous_start, '@class.outer' },
        ['[M'] = { move.goto_previous_end, '@function.outer' },
        ['[]'] = { move.goto_previous_end, '@class.outer' },
      }
      for lhs, spec in pairs(moves) do
        local fn, query = spec[1], spec[2]
        vim.keymap.set({ 'n', 'x', 'o' }, lhs, function()
          fn(query, 'textobjects')
        end, { desc = 'Move to ' .. query })
      end

      vim.keymap.set('n', '<leader>a', function()
        swap.swap_next '@parameter.inner'
      end, { desc = 'Swap next parameter' })
      vim.keymap.set('n', '<leader>A', function()
        swap.swap_previous '@parameter.inner'
      end, { desc = 'Swap previous parameter' })
    end,
  },
}

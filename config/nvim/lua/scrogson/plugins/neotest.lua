return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'jfpedroza/neotest-elixir',
    'rouge8/neotest-rust',
  },
  config = function()
    local neotest = require 'neotest'
    local opts = { noremap = true, silent = true, nowait = true }

    neotest.setup {
      adapters = {
        require 'neotest-elixir',
        require 'neotest-rust',
      },
    }

    vim.keymap.set('n', '<leader>tf', function()
      neotest.run.run(vim.fn.expand '%')
      neotest.output.open { last_run = true, enter = true }
    end, opts)

    vim.keymap.set('n', '<leader>tr', function()
      neotest.run.run()
      neotest.output.open { last_run = true, enter = true }
    end, opts)

    vim.keymap.set('n', '<leader>to', function()
      neotest.output.open { last_run = true, enter = true }
    end)

    vim.keymap.set('n', '<leader>tt', function()
      neotest.summary.toggle()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-w>=', false, true, true), 'n', false)
    end, opts)
  end,
}

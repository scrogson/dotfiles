return {
  'nvim-telescope/telescope-ui-select.nvim',
  'imsnif/kdl.vim',
  'sam4llis/nvim-lua-gf',
  'tpope/vim-surround',

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end,
  },
  {
    'zbirenbaum/copilot.lua',
    config = function()
      require('copilot').setup {}
    end,
  },

  {
    'zbirenbaum/copilot-cmp',
    config = function()
      require('copilot_cmp').setup {}
    end,
  },
}

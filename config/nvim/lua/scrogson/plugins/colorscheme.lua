return {
  'projekt0n/github-nvim-theme',
  lazy = false,
  priority = 1000,
  config = function()
    require('github-theme').setup {}
    vim.cmd.colorscheme 'github_dark_dimmed'
  end,
}

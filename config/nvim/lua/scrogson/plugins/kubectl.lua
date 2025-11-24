return {
  'Ramilito/kubectl.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  -- Build Go library first, then Rust component
  build = 'make build',
  config = function()
    require('kubectl').setup({
      -- Optional: customize configuration
      -- See https://github.com/Ramilito/kubectl.nvim#configuration
    })

    -- Keybindings for kubectl.nvim
    vim.keymap.set('n', '<leader>k', '<cmd>lua require("kubectl").toggle()<cr>', {
      desc = '[K]ubectl toggle',
      noremap = true,
      silent = true,
    })

    -- Note: Our custom :K8sDB command and <leader>dk mapping
    -- are for database-specific workflows via DBUI
  end,
}

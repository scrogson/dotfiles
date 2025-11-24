return {
  -- Add indentation guides even on blank lines
  'lukas-reineke/indent-blankline.nvim',
  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- See `:help ibl`
  main = 'ibl',
  opts = {},
  config = function()
    require('ibl').setup {
      indent = {
        char = '│',  -- Thin vertical line character
      },
      scope = {
        show_start = false,
        show_end = false,
      },
    }

    -- Set up autocmd to adjust indent colors based on background
    vim.api.nvim_create_autocmd({ 'ColorScheme', 'VimEnter' }, {
      pattern = '*',
      callback = function()
        if vim.o.background == 'light' then
          -- Light theme: use very light gray for indent guides
          vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#d0d0d0' })
          vim.api.nvim_set_hl(0, 'IblScope', { fg = '#b0b0b0' })
        else
          -- Dark theme: use darker gray for indent guides
          vim.api.nvim_set_hl(0, 'IblIndent', { fg = '#3b3b3b' })
          vim.api.nvim_set_hl(0, 'IblScope', { fg = '#5b5b5b' })
        end
      end,
    })
  end,
}

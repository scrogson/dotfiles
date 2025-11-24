return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local lualine = require 'lualine'
    local lazy_status = require 'lazy.status' -- to configure lazy pending updates count

    -- Function to get theme based on background
    local function get_lualine_theme()
      if vim.o.background == 'dark' then
        return 'github_dark_dimmed'
      else
        return 'github_light'
      end
    end

    -- configure lualine with modified theme
    lualine.setup {
      options = {
        theme = get_lualine_theme(),
      },
      sections = {
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = '#ff9e64' },
          },
          { 'encoding' },
          { 'fileformat' },
          { 'filetype' },
        },
      },
    }

    -- Update lualine when colorscheme changes or focus is gained
    vim.api.nvim_create_autocmd({ 'ColorScheme', 'FocusGained' }, {
      pattern = '*',
      callback = function()
        lualine.setup {
          options = {
            theme = get_lualine_theme(),
          },
          sections = {
            lualine_x = {
              {
                lazy_status.updates,
                cond = lazy_status.has_updates,
                color = { fg = '#ff9e64' },
              },
              { 'encoding' },
              { 'fileformat' },
              { 'filetype' },
            },
          },
        }
      end,
    })
  end,
}

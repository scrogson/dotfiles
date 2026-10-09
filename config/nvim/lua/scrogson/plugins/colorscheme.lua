return {
  'projekt0n/github-nvim-theme',
  lazy = false,
  priority = 1000,
  config = function()
    require('github-theme').setup {
      options = {
        modules = {
          indent_blankline = false,
        },
      },
      groups = {
        github_dark_dimmed = {
          IblIndent = { fg = '#2a2a2a' },
          IblScope = { fg = '#3a3a3a' },
          NeoTreeIndentMarker = { fg = '#2a2a2a' },
        },
        github_light = {
          IblIndent = { fg = '#d0d0d0' },
          IblScope = { fg = '#b0b0b0' },
          NeoTreeIndentMarker = { fg = '#d0d0d0' },
        },
      },
    }

    -- Function to detect system appearance mode (macOS or Linux)
    local function get_system_appearance()
      local handle = io.popen(vim.fn.expand '~/.dotfiles/scripts/theme-mode.sh' .. ' 2>/dev/null')
      if handle then
        local result = handle:read('*a')
        handle:close()
        if result:match('dark') then
          return 'dark'
        end
      end
      return 'light'
    end

    -- Function to set theme based on system appearance
    local function set_theme_from_system()
      local appearance = get_system_appearance()
      if appearance == 'dark' then
        vim.o.background = 'dark'
        vim.cmd.colorscheme 'github_dark_dimmed'
      else
        vim.o.background = 'light'
        vim.cmd.colorscheme 'github_light'
      end
    end

    -- Set theme on startup
    set_theme_from_system()

    -- Auto-detect theme changes when Neovim gains focus
    vim.api.nvim_create_autocmd('FocusGained', {
      pattern = '*',
      callback = set_theme_from_system,
    })
  end,
}

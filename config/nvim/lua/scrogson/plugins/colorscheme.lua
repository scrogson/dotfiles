return {
  'projekt0n/github-nvim-theme',
  lazy = false,
  priority = 1000,
  config = function()
    require('github-theme').setup {}

    -- Function to detect macOS appearance mode
    local function get_system_appearance()
      local handle = io.popen('defaults read -g AppleInterfaceStyle 2>/dev/null')
      if handle then
        local result = handle:read('*a')
        handle:close()
        if result:match('Dark') then
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

return {
  'mhartington/formatter.nvim',
  config = function()
    -- Utilities for creating configurations
    local util = require 'formatter.util'

    -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
    require('formatter').setup {
      -- Enable or disable logging
      logging = true,
      -- Set the log level
      log_level = vim.log.levels.WARN,
      -- All formatter configurations are opt-in
      filetype = {
        -- Formatter configurations for filetype "lua" go here
        -- and will be executed in order
        lua = {
          -- "formatter.filetypes.lua" defines default configurations for the
          -- "lua" filetype
          require('formatter.filetypes.lua').stylua,
        },

        rust = {
          require('formatter.filetypes.rust').rustfmt,
        },

        elixir = {
          require('formatter.filetypes.elixir').mixformat,
        },

        javascript = {
          require('formatter.filetypes.javascript').prettier,
        },

        typescript = {
          require('formatter.filetypes.typescript').prettier,
        },

        typescriptreact = {
          require('formatter.filetypes.typescriptreact').prettier,
        },

        html = {
          require('formatter.filetypes.html').prettier,
        },

        markdown = {
          require('formatter.filetypes.markdown').prettier,
        },

        sql = {
          require('formatter.filetypes.sql').pgformat,
        },

        -- Use the special "*" filetype for defining formatter configurations on
        -- any filetype
        ['*'] = {
          -- "formatter.filetypes.any" defines default configurations for any
          -- filetype
          require('formatter.filetypes.any').remove_trailing_whitespace,
        },
      },
    }
  end,
}

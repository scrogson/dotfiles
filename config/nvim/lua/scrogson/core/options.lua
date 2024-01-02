-- Set comma as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set shell to /bin/bash
vim.o.shell = '/bin/bash'

-- Treat dash-separated words as a word text object
-- vim.bo.iskeyword = vim.bo.iskeyword .. '-'

-- Enable hidden buffers
vim.o.hidden = true

-- Disable line wrapping
vim.wo.wrap = false

-- Set encoding to UTF-8
vim.o.encoding = 'utf-8'

-- Set popup menu height
vim.o.pumheight = 10

-- Set file encoding to UTF-8
vim.o.fileencoding = 'utf-8'

-- Show ruler with cursor position
vim.o.ruler = true

-- Set command line height
vim.o.cmdheight = 0

-- Enable mouse support
vim.o.mouse = 'a'

-- Place horizontal splits below
vim.o.splitbelow = true

-- Place vertical splits to the right
vim.o.splitright = true

-- Set terminal to support 256 colors
vim.o.termguicolors = true

-- Disable conceal level
vim.o.conceallevel = 0

-- Set tabstop, softtabstop, shiftwidth, and expandtab
vim.bo.tabstop = 2
vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true

-- Enable smart indent
vim.o.smartindent = true

-- Enable auto-indent
vim.o.autoindent = true

-- Always display status line
vim.o.laststatus = 2

-- Show line numbers
vim.wo.number = true

-- Enable cursor line highlighting
vim.wo.cursorline = true

-- Set background to dark
vim.o.background = 'dark'

-- Disable showmode
vim.o.showmode = false

-- Disable swap files
vim.o.swapfile = false

-- Disable backup files
vim.o.backup = false

-- Disable write backup files
vim.o.writebackup = false

-- Set shortmess option
vim.o.shortmess = vim.o.shortmess .. 'c'

-- Always show the sign column
vim.wo.signcolumn = 'yes'

-- Set updatetime for faster completion
vim.o.updatetime = 250

-- Set timeoutlen
vim.o.timeoutlen = 300

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable search result highlighting
vim.o.hlsearch = true

-- Enable incremental search
vim.o.incsearch = true

-- Ignore case when searching
vim.o.ignorecase = true

-- Enable smartcase for searching
vim.o.smartcase = true

-- Set number formats
vim.o.nrformats = ''

-- Set scrolloff to keep more context when scrolling
vim.o.scrolloff = 3

-- Disable error bells
vim.o.errorbells = false

-- Enable visual bell
vim.o.visualbell = true

-- Highlight matching parentheses and other pairs
vim.o.showmatch = true

-- Set textwidth for auto-wrapping
vim.bo.textwidth = 80

-- Enable autoread
vim.o.autoread = true

-- Set terminal title
vim.o.title = true

-- Display placeholders for tabs and trailing spaces
vim.opt.listchars = { tab = '▸ ', eol = '¬' }
vim.opt.list = false

-- Set modelines
vim.o.modelines = 0

-- Set backspace options
vim.o.backspace = 'indent,eol,start'

-- Set history
vim.o.history = 1000

-- Set undo levels
vim.o.undolevels = 1000

-- Set directory for temporary files
vim.o.directory = '/tmp'

-- Set grepprg
vim.o.grepprg = 'rg --vimgrep'

-- Set formatoptions
vim.o.formatoptions = 'croqln2'

-- Map 'w!!' to 'w !sudo tee %'
vim.cmd 'cmap w!! w !sudo tee %'

-- Automatically write changes to init.vim on FocusLost
vim.cmd 'autocmd FocusLost * :wa'

-- Automatically source the config file after saving it
vim.cmd 'au! BufWritePost $MYVIMRC source %'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

vim.api.nvim_create_augroup('__formatter__', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  group = '__formatter__',
  command = ':FormatWrite',
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.html',
  callback = function()
    vim.bo.filetype = 'htmldjango'
  end,
})

vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {},
  -- LSP configuration
  server = {
    on_attach = function(client, bufnr)
      -- you can also put keymaps in here
    end,
    settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {
        diagnostics = {
          enable = true,
          disabled = { 'unresolved-proc-macro' },
          enableExperimental = true,
        },
      },
    },
  },
  -- DAP configuration
  dap = {},
}

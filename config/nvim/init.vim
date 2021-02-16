source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/settings.vim
source $HOME/.config/nvim/bindings.vim
source $HOME/.config/nvim/plugins/better-whitespace.vim
source $HOME/.config/nvim/plugins/elixir.vim
source $HOME/.config/nvim/plugins/fzf.vim
source $HOME/.config/nvim/plugins/lightline.vim

colorscheme gruvbox

" Elixir
"let g:mix_format_on_save = 1

" Rust
"let g:rustfmt_command = "rustfmt +nightly"
"let g:rustfmt_autosave = 1
"let g:rust_clip_command = 'xclip -selection clipboard'

" Prettier
"let g:prettier#autoformat = 0
"let g:prettier#config#bracket_spacing = 'true'
"let g:prettier#config#arrow_parens = 'avoid'
"let g:prettier#config#jsx_bracket_same_line = 'false'
"let g:prettier#config#single_quote = 'false'
"let g:prettier#config#semi = 'false'
"autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync

"set grepprg=rg\ --vimgrep

"nmap <silent> <leader>r :TestNearest<cr>
"nmap <silent> <leader>R :TestFile<cr>
"nmap <silent> <leader>a :TestSuite<cr>
"nmap <silent> <leader>l :TestLast<cr>
"nmap <silent> <leader>g :TestVisit<cr>
" run tests in neovim strategy
"let g:test#strategy = 'neovim'

" Gist
"let g:gist_clip_command = 'pbcopy' " Use pbcopy for clipboard
"let g:gist_detect_filetype = 1 " Detect filetypes
"let g:gist_open_browser_after_post = 1 " Open the gist after posting

" Ag
"let g:agprg="rg --column"

" === NERDTree === "
noremap <C-n> :NERDTreeToggle<CR>
"  <C-n> - Toggle NERDTree on/off
"  <C-f> - Opens current file location in NERDTree
nmap <C-f> :NERDTreeFind<CR>


" Remove bookmarks and help text from NERDTree
let g:NERDTreeMinimalUI = 1
" Hide certain files and directories from NERDTree
let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']
" Hide the Nerdtree status line to avoid clutter
let g:NERDTreeStatusline = ''

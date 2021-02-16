"  <C-n> - Toggle NERDTree on/off
noremap <C-n> :NERDTreeToggle<CR>
"  <C-f> - Opens current file location in NERDTree
nmap <C-f> :NERDTreeFind<CR>

" Remove bookmarks and help text from NERDTree
let g:NERDTreeMinimalUI = 1
" Hide certain files and directories from NERDTree
let g:NERDTreeIgnore = ['^\.DS_Store$', '^tags$', '\.git$[[dir]]', '\.idea$[[dir]]', '\.sass-cache$']
" Hide the Nerdtree status line to avoid clutter
let g:NERDTreeStatusline = ''

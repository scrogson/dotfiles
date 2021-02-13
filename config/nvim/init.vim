set encoding=utf-8
source ~/.config/nvim/plugins.vim

" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

" Fish doesn't play all that well with others
set shell=/bin/bash

set mouse=""
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2

let g:mapleader=','

set clipboard=unnamedplus

" ============================================================================ "
" ===                           PLUGIN SETUP                               === "
" ============================================================================ "

" === Coc.nvim === "
" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

"Close preview window when completion is done.
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" === NeoSnippet === "
" Map <C-k> as shortcut to activate snippet if available
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" Load custom snippets from snippets folder
let g:neosnippet#snippets_directory='~/.config/nvim/snippets'

" Hide conceal markers
let g:neosnippet#enable_conceal_markers = 0

" Elixir
let g:mix_format_on_save = 1

" Rust
let g:rustfmt_command = "rustfmt +nightly"
let g:rustfmt_autosave = 1
let g:rust_clip_command = 'xclip -selection clipboard'

" LanguageClient
let g:LanguageClient_autoStart = 1
let g:LanguageClient_changeThrottle = 1.0
let g:LanguageClient_serverCommands = {
  \ 'rust': ['rustup', 'run', 'nightly', 'rls']
  \ }


" Prettier
let g:prettier#autoformat = 0
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#arrow_parens = 'avoid'
let g:prettier#config#jsx_bracket_same_line = 'false'
let g:prettier#config#single_quote = 'false'
let g:prettier#config#semi = 'false'
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync

" FZF
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

set grepprg=rg\ --vimgrep

nmap <silent> <leader>r :TestNearest<cr>
nmap <silent> <leader>R :TestFile<cr>
nmap <silent> <leader>a :TestSuite<cr>
nmap <silent> <leader>l :TestLast<cr>
nmap <silent> <leader>g :TestVisit<cr>
" run tests in neovim strategy
let g:test#strategy = 'neovim'

" Execute code checks, find mistakes, in the background
"Plug 'neomake/neomake'
"augroup localneomake
  ""autocmd! BufWritePost * Neomake
"augroup END
let g:neomake_markdown_enabled_makers = []

let g:alchemist_tag_disable = 1

let g:lightline = {
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'cocstatus', 'gitbranch', 'readonly', 'filename', 'modified' ] ]
  \ },
  \ 'component_function': {
  \   'cocstatus': 'coc#status',
  \   'gitbranch': 'fugitive#head',
  \   'readonly': 'LightlineReadonly',
  \   'mode': 'LightlineMode',
  \ },
  \ }

function! LightlineReadonly()
  return &readonly && &filetype !=# 'help' ? 'RO' : ''
endfunction

function! LightlineMode()
  return expand('%:t') ==# 'NERD_tree' ? 'NERD' : lightline#mode()
endfunction

" Gist
let g:gist_clip_command = 'pbcopy' " Use pbcopy for clipboard
let g:gist_detect_filetype = 1 " Detect filetypes
let g:gist_open_browser_after_post = 1 " Open the gist after posting

" Ag
let g:agprg="rg --column"

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

map <leader>t :GFiles --exclude-standard --others --cached<cr>
map <leader>b :Buffers<cr>

" Deactivate Wrapping
set nowrap
" Treat all numbers as decimal
set nrformats=
" I don't like Swapfiles
set noswapfile
" Don't make a backup before overwriting a file.
set nobackup
" And again.
set nowritebackup

" Turn on line numbers
set number

" Highlight search results
set hlsearch

" Incremental search, search as you type
set incsearch

" Ignore case when searching
set ignorecase

" Ignore case when searching lowercase
set smartcase

" Keep more context when scrolling off the end of a buffer
set scrolloff=3
set autoindent
set smartindent
set showmode
set showcmd

" Hide buffers instead of closing
set hidden
set wildmenu
set wildmode=list:longest
set wildignore=*.swp,tmp,.git,*.png,*.jpg,*.gif,node_modules,bower_components,deps,_build,./bin,doc,mnesia,log,logs,target,elm\-stuff

set ttyfast

" Disable line/column number in status line
" Shows up in preview window when airline is disabled if not
set noruler

set laststatus=2
set modelines=0
set backspace=indent,eol,start
set history=1000

" no bell please
set visualbell

" shut up
set noerrorbells

" Set the command height to 1 lines
set cmdheight=1

" Highlight closing ), >, }, ], etc...
set showmatch
set undolevels=1000
set directory=/tmp
set textwidth=79

" Formatting
set formatoptions=c  " Format comments
set formatoptions+=r " Continue comments by default
set formatoptions+=l " Don't break lines that are already long
set formatoptions+=o " Make comment when using o or O from comment line
set formatoptions+=q " Format comments with gq
set formatoptions+=n " Recognize numbered lists
set formatoptions+=2 " Use indent from 2nd line of a paragraph
set formatoptions+=1 " Break before 1-letter words
set textwidth=80     " Set Where Text Should Auto-Wrap
set autoread 				 " Make sure that buffers change if the file changed

" key mappings

" Stop highlighting
map <leader><space> :noh<cr>
imap jj <esc>

" Set the title of the terminal tab
set title

" Display a place holder character for tabs and trailing spaces
set listchars=tab:▸\ ,eol:¬

command! W :w

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

set winwidth=84
set winheight=10
set winminheight=10
set winheight=999

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
inoremap jj <ESC>
inoremap II <Esc>I
inoremap AA <Esc>A
inoremap OO <Esc>O
nnoremap / /\v
vnoremap / /\v

" strip all trailing whitespace in the current file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" fold tag
nnoremap <leader>ft Vatzf
" open .vimrc file
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
" Fix those pesky situations where you edit & need sudo to save
cmap w!! w !sudo tee % >/dev/null

autocmd FocusLost * :wa

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)


syntax on
syntax enable
set t_Co=256

set background=dark
try
  colorscheme solarized
catch
  colorscheme OceanicNext
endtry

filetype plugin on

" Change vertical split character to be a space (essentially hide it)
set fillchars+=vert:\|,eob:\ 

" Set preview window to appear at bottom
set splitbelow

" Don't dispay mode in command line (airilne already shows it)
set noshowmode

" Set floating window to be slightly transparent
"set winbl=10

" coc.nvim color changes
hi! link CocErrorSign WarningMsg
hi! link CocWarningSign Number
hi! link CocInfoSign Type

highlight clear ALEErrorSign
highlight clear ALEWarningSign
highlight clear SignColumn
highlight clear VertSplit

" Make background transparent for many things
"hi! Normal ctermbg=NONE guibg=NONE
"hi! NonText ctermbg=NONE guibg=NONE
"hi! LineNr ctermfg=NONE guibg=NONE
"hi! SignColumn ctermfg=NONE guibg=NONE
"hi! StatusLine guifg=#16252b guibg=#6699CC
"hi! StatusLineNC guifg=#16252b guibg=#16252b

" Try to hide vertical spit and end of buffer symbol
hi! VertSplit gui=NONE guifg=#17252c guibg=#17252c
hi! EndOfBuffer ctermbg=NONE ctermfg=NONE guibg=#17252c guifg=#17252c

" Customize NERDTree directory
hi! NERDTreeCWD guifg=#99c794

" Make background color transparent for git changes
hi! SignifySignAdd guibg=NONE
hi! SignifySignDelete guibg=NONE
hi! SignifySignChange guibg=NONE

" Highlight git change signs
hi! SignifySignAdd guifg=#99c794
hi! SignifySignDelete guifg=#ec5f67
hi! SignifySignChange guifg=#c594c5

" Call method on window enter
augroup WindowManagement
  autocmd!
  autocmd WinEnter * call Handle_Win_Enter()
augroup END

" Change highlight group of preview window when open
function! Handle_Win_Enter()
  if &previewwindow
    setlocal winhighlight=Normal:MarkdownError
  endif
endfunction

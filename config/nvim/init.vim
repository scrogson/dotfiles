" Fish doesn't play all that well with others
set shell=/bin/bash

set encoding=utf-8

set mouse=""
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2

let g:mapleader=','

" Use the clipboard of Mac OS
if has('mac')
  "set clipboard=unnamed
end

"""""""""""""""""""""""""""""""""""""""""
" Plugins
"""""""""""""""""""""""""""""""""""""""""

call plug#begin('~/.config/nvim/plugged')

Plug 'neoclide/coc.nvim', {'tag': '*', 'do': 'yarn install'}

" Polyglot loads language support on demand!
Plug 'sheerun/vim-polyglot'
Plug 'w0rp/ale'

" Linter
let g:ale_sign_column_always = 1
" only lint on save
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_save = 0
let g:ale_lint_on_enter = 0
let g:ale_rust_cargo_use_check = 1
let g:ale_rust_cargo_check_all_targets = 1

Plug 'rust-lang/rust.vim'
let g:rustfmt_command = "rustfmt +nightly"
let g:rustfmt_autosave = 1
let g:rust_clip_command = 'xclip -sel clip'

Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
let g:LanguageClient_autoStart = 1
let g:LanguageClient_changeThrottle = 1.0
let g:LanguageClient_serverCommands = {
  \ 'rust': ['rustup', 'run', 'nightly', 'rls']
  \ }

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue'] }

let g:prettier#autoformat = 0
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#arrow_parens = 'avoid'
let g:prettier#config#jsx_bracket_same_line = 'false'
let g:prettier#config#single_quote = 'false'
let g:prettier#config#semi = 'false'
autocmd BufWritePre *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue PrettierAsync

" LanguageClient enhancements
" Showing function signature and inline doc.
Plug 'Shougo/echodoc.vim'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

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

Plug 'Raimondi/delimitMate'

Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_cache_dir = '~/.tags_cache'

" required for some navigation features
Plug 'tpope/vim-projectionist'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-rails'

Plug 'mattn/emmet-vim'

" Run tests with varying granularity
Plug 'janko-m/vim-test'
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

Plug 'slashmili/alchemist.vim'
let g:alchemist_tag_disable = 1
Plug 'powerman/vim-plugin-AnsiEsc'

" Color themes
Plug 'altercation/vim-colors-solarized'

Plug 'itchyny/lightline.vim'
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
Plug 'edkolev/tmuxline.vim'

function! LightlineReadonly()
  return &readonly && &filetype !=# 'help' ? 'RO' : ''
endfunction

function! LightlineMode()
  return expand('%:t') ==# 'NERD_tree' ? 'NERD' : lightline#mode()
endfunction

" Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
let g:gist_clip_command = 'pbcopy' " Use pbcopy for clipboard
let g:gist_detect_filetype = 1 " Detect filetypes
let g:gist_open_browser_after_post = 1 " Open the gist after posting

Plug 'epmatsw/ag.vim'

let g:agprg="rg --column"

Plug 'scrooloose/nerdcommenter'

Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
noremap <C-n> :NERDTreeToggle<CR>

"Plug 'airblade/vim-gitgutter'
" without any weird color
"highlight clear SignColumn

Plug 'ctrlpvim/ctrlp.vim'
" CtrlP configs
map <leader>t :CtrlP<cr>
map <leader>b :CtrlPBuffer<cr>
" Change the files match to the top of the list
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_height = 30
" Open multiple files in no more than 2 vertical splits
let g:ctrlp_open_multiple_files = '2vjr'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""
" End Plugins
"""""""""""""""""""""""""""""""""""""""""

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

set number " turn on line numbers
set hlsearch " Highlight search results
set incsearch " Incremental search, search as you type
set ignorecase " Ignore case when searching
set smartcase " Ignore case when searching lowercase
set scrolloff=3 " Keep more context when scrolling off the end of a buffer
set autoindent
set smartindent
set showmode
set showcmd

set hidden
set wildmenu
set wildmode=list:longest
set wildignore=*.swp,tmp,.git,*.png,*.jpg,*.gif,node_modules,bower_components,deps,_build,./bin,doc,mnesia,log,logs,target,elm\-stuff

set ttyfast
set ruler
set laststatus=2
set modelines=0
set backspace=indent,eol,start
set history=1000
set visualbell " no bell please
set noerrorbells " shut up
set cmdheight=1		 " Set the command height to 1 lines
set showmatch				 " Highlight closing ), >, }, ], etc...
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
map <leader><space> :noh<cr> " Stop highlighting
imap jj <esc>

set title " Set the title of the terminal tab

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

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

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
colorscheme solarized
filetype plugin on
set noshowmode

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

" Polyglot loads language support on demand!
Plug 'sheerun/vim-polyglot'

Plug 'rust-lang/rust.vim'
let g:autofmt_autosave = 1
let g:rust_clip_command = 'xclip -sel clip'

Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'make release'}
let g:LanguageClient_autoStart = 1
let g:LanguageClient_changeThrottle = 1.0
let g:LanguageClient_serverCommands = {
  \ 'rust': ['rustup', 'run', 'nightly', 'rls']
  \ }

noremap <silent> K :call LanguageClient_textDocument_hover()<cr>
noremap <silent> gd :call LanguageClient_textDocument_definition()<cr>
noremap <silent> <F2> :call LanguageClient_textDocument_rename()<cr>

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

" Completions
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
" use tab for completion
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

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
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
let g:airline_powerline_fonts = 1
let g:airline_detect_modified = 1
let g:airline_detect_paste    = 1
let g:airline_theme           = 'solarized'
let g:airline_exclude_preview = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
  "let g:airline_symbols.branch = "\uf020"
  "let g:airline_symbols.branch = '± '
  let g:airline_symbols.branch = ' '
endif

" Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
let g:gist_clip_command = 'pbcopy' " Use pbcopy for clipboard
let g:gist_detect_filetype = 1 " Detect filetypes
let g:gist_open_browser_after_post = 1 " Open the gist after posting

Plug 'epmatsw/ag.vim'

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
set cmdheight=2			 " Set the command height to 2 lines
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

syntax on
syntax enable
set t_Co=256
set background=dark
colorscheme solarized
filetype plugin on

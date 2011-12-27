" Vundle and bundle configuration
source ~/.vundlerc

set encoding=utf-8

" Colors
colorscheme lithium_dark

" Basic
let mapleader = ","
let gmapleader = ","
set ignorecase
set smartcase
set gdefault
set incsearch
set hlsearch
set scrolloff=3
set title

set autoindent
set smartindent

set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set wildignore=*.swp,tmp,.git,*.png,*.jpg,*.gif

set ttyfast
set ruler
set laststatus=2
set term=screen
set modelines=0
set backspace=indent,eol,start
set history=100
set visualbell " no bell please
set noerrorbells " shut up
set nowrap
set number
set ruler
set colorcolumn=80
set cmdheight=2 " Set the command height to 2 lines
set showmatch " Highlight closing ), >, }, ], etc...
set undolevels=1000
set directory=/tmp
set nowrap
set textwidth=79
set formatoptions=qrn1
set autoread " Make sure that buffers change if the file changed

" Display a place holder character for tabs and trailing spaces
set listchars=tab:▸\ ,eol:¬

" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
" Set line numbers to relative
nmap <leader>r :set relativenumber<cr>
" Toggle cursorline
nmap <leader>c :set cursorline!<cr>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
inoremap jj <ESC>
nnoremap / /\v
vnoremap / /\v
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %
" strip all trailing whitespace in the current file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" fold tag
nnoremap <leader>ft Vatzf
" open .vimrc file
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

au FocusLost * :wa
autocmd FileType php setlocal ts=4 sts=4 sw=4 noexpandtab
autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType javascript,html,css setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType ruby,pml,erb,haml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType markdown setlocal wrap linebreak nolist
autocmd BufNewFile,BufRead *.rss setfiletype xml
autocmd BufNewFile,BufRead *.scss setfiletype css.scss
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline

if has("autocmd")
  " Enable filetype detection
  filetype plugin indent on
  " Restore cursor position
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif

if &t_Co > 2 || has("gui_running")
  " Enable syntax highlighting
  syntax on
endif

" Surround Plugin config
let g:surround_{char2nr('-')} = "<% \r %>"
let g:surround_{char2nr('=')} = "<%= \r %>"
let g:surround_{char2nr('8')} = "/* \r */"
let g:surround_{char2nr('s')} = " \r "
let g:surround_{char2nr('^')} = "/^\r$/"
let g:surround_indent = 1

" ZenCoding
let g:user_zen_expander_key = '<c-e>'
let g:use_zen_complete_tag = 1
let g:user_zen_settings = {
  \  'php' : {
  \    'extends' : 'html',
  \    'filters' : 'c',
  \  },
  \  'xml' : {
  \    'extends' : 'html',
  \  },
  \  'haml' : {
  \    'extends' : 'html',
  \  },
  \}

" Fix those pesky situations where you edit & need sudo to save
cmap w!! w !sudo tee % >/dev/null

" Status line
let g:git_branch_status_nogit="" 
let g:git_branch_status_head_current=1
set statusline=%f\ %m%=%l,\ %c\ %#String#%{GitBranchInfoString()}\ %y

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Re-index Command-T after a new file has been written to the file system
augroup CommandTExtension
  autocmd!
  autocmd FocusGained * CommandTFlush
  autocmd BufWritePost * CommandTFlush
augroup END

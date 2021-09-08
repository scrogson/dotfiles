syntax enable                           " Enables syntax highlighing

set shell=/bin/bash
set iskeyword+=-                      	" treat dash separated words as a word text object"
set hidden                              " Required to keep multiple buffers open multiple buffers
set nowrap                              " Display long lines as just one line
set encoding=utf-8                      " The encoding displayed
set pumheight=10                        " Makes popup menu smaller
set fileencoding=utf-8                  " The encoding written to file
set ruler              			            " Show the cursor position all the time
set cmdheight=2                         " More space for displaying messages
set mouse=a                             " Enable your mouse
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set t_Co=256                            " Support 256 colors
set conceallevel=0                      " So that I can see `` in markdown files
set tabstop=2                           " Insert 2 spaces for a tab
set softtabstop=2
set shiftwidth=2                        " Change the number of space characters inserted for indentation
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set autoindent                          " Good auto indent
set laststatus=2                        " Always display the status line
set number                              " Line numbers
set cursorline                          " Enable highlighting of the current line
set background=dark                     " tell vim what the background color looks like
set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set noswapfile                          " No swap files please
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc
set shortmess+=c                        " Don't pass messages to |ins-completion-menu|.
set signcolumn=yes                      " Always show the signcolumn, otherwise it would shift the text each time
set updatetime=300                      " Faster completion
set timeoutlen=500                      " By default timeoutlen is 1000 ms
set clipboard=unnamedplus               " Copy paste between vim and everything else
set hlsearch                            " Highlight search results
set incsearch                           " Incremental search, search as you type
set ignorecase                          " Ignore case when searching
set smartcase                           " Ignore case when searching lowercase
set nrformats=                          " Treat all numbers as decimal
set scrolloff=3                         " Keep more context when scrolling off the end of a buffer
set noerrorbells                        " shut up please
set visualbell                          " no bell please
set showmatch                           " Highlight closing ), >, }, ], etc...
set textwidth=80                        " Set Where Text Should Auto-Wrap
set autoread                            " Make sure that buffers change if the file changed
set title                               " Set the title of the terminal tab
set listchars=tab:▸\ ,eol:¬             " Display a place holder character for tabs and trailing spaces
"set winbl=10                            " Set floating window to be slightly transparent

" Formatting
set formatoptions=c  " Format comments
set formatoptions+=r " Continue comments by default
set formatoptions+=l " Don't break lines that are already long
set formatoptions+=o " Make comment when using o or O from comment line
set formatoptions+=q " Format comments with gq
set formatoptions+=n " Recognize numbered lists
set formatoptions+=2 " Use indent from 2nd line of a paragraph
set formatoptions+=1 " Break before 1-letter words

set noshowcmd
set wildmenu
set wildmode=list:longest
set wildignore=*.swp,tmp,.git,*.png,*.jpg,*.gif,node_modules,bower_components,deps,_build,./bin,doc,mnesia,log,logs,target,elm\-stuff
set modelines=0
set backspace=indent,eol,start
set history=1000
set undolevels=1000
set directory=/tmp
set grepprg=rg\ --vimgrep

" New stuff
" set notimeout nottimeout
" set scrolloff=1
" set sidescroll=1
" set sidescrolloff=1
" set display+=lastline
" set backspace=eol,start,indent
" set nostartofline
" let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" set mmp=1300
" set autochdir                           " Your working directory will always be the same as your working directory
" set foldcolumn=2                        " Folding abilities

" You can't stop me
cmap w!! w !sudo tee %

autocmd FocusLost * :wa
au! BufWritePost $MYVIMRC source %      " auto source when writing to init.vm alternatively you can run :source $MYVIMRC

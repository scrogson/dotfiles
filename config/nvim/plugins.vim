" ============================================================================ "
" ===                               PLUGINS                                === "
" ============================================================================ "

" check whether vim-plug is installed and install it if necessary
let plugpath = expand('<sfile>:p:h'). '/autoload/plug.vim'
if !filereadable(plugpath)
    if executable('curl')
        let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        call system('curl -fLo ' . shellescape(plugpath) . ' --create-dirs ' . plugurl)
        if v:shell_error
            echom "Error downloading vim-plug. Please install it manually.\n"
            exit
        endif
    else
        echom "vim-plug not installed. Please install it manually or install curl.\n"
        exit
    endif
endif

call plug#begin('~/.config/nvim/plugged')

" === Editing Plugins === "
" Trailing whitespace highlighting & automatic fixing
Plug 'ntpeters/vim-better-whitespace'

" auto-close plugin
Plug 'rstacruz/vim-closer'

" Improved motion in Vim
Plug 'easymotion/vim-easymotion'

" Intellisense Engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Denite - Fuzzy finding, buffer management
Plug 'epmatsw/ag.vim'

" Snippet support
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

" LanguageClient enhancements
" Showing function signature and inline doc.
Plug 'Shougo/echodoc.vim'

" === Git Plugins === "
" Enable git changes to be shown in sign column
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'

" === Javascript Plugins === "
" Typescript syntax highlighting
Plug 'HerringtonDarkholme/yats.vim'

" ReactJS JSX syntax highlighting
Plug 'mxw/vim-jsx'

" Generate JSDoc commands based on function signature
Plug 'heavenshell/vim-jsdoc'

" === Syntax Highlighting === "

" Syntax highlighting for nginx
Plug 'chr4/nginx.vim'

" Syntax highlighting for javascript libraries
Plug 'othree/javascript-libraries-syntax.vim'

" Improved syntax highlighting and indentation
Plug 'othree/yajs.vim'

Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue'] }

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" === UI === "
" File explorer
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdcommenter'

" Colorscheme
Plug 'mhartington/oceanic-next'
Plug 'altercation/vim-colors-solarized'

" Customized vim status line
Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'

" Icons
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Polyglot loads language support on demand!
Plug 'sheerun/vim-polyglot'

" Elixir
Plug 'mhinz/vim-mix-format'
Plug 'slashmili/alchemist.vim'
Plug 'powerman/vim-plugin-AnsiEsc'

" Rust
Plug 'rust-lang/rust.vim'

Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}

Plug 'Raimondi/delimitMate'
" required for some navigation features
Plug 'tpope/vim-projectionist'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-rails'

Plug 'mattn/emmet-vim'

" Run tests with varying granularity
Plug 'janko-m/vim-test'

"Plug 'w0rp/ale'

" Linter
"let g:ale_sign_column_always = 1
"" only lint on save
"let g:ale_lint_on_text_changed = 'never'
"let g:ale_lint_on_save = 0
"let g:ale_lint_on_enter = 0
"let g:ale_rust_cargo_use_check = 1
"let g:ale_rust_cargo_check_all_targets = 1
""let g:ale_sign_error = ''
"let g:ale_sign_error = '=='
""let g:ale_sign_style_error = ''

" Initialize plugin system
call plug#end()

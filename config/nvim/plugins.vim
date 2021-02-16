" check whether vim-plug is installed and install it if necessary
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

set nocompatible

call plug#begin('~/.config/nvim/autoload/plugged')

" Polyglot loads language support on demand!
Plug 'sheerun/vim-polyglot'
Plug 'jidn/vim-dbml'
Plug 'elixir-editors/vim-elixir'
Plug 'mhinz/vim-mix-format'

" Intellisense Engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'editorconfig/editorconfig-vim'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Trailing whitespace highlighting & automatic fixing
Plug 'ntpeters/vim-better-whitespace'

" auto-close plugin
Plug 'jiangmiao/auto-pairs'

" === Git Plugins === "
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'

" === UI === "
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

Plug 'mhartington/oceanic-next'
Plug 'altercation/vim-colors-solarized'
Plug 'gruvbox-community/gruvbox'

Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'

Plug 'tpope/vim-surround'

" Snippets
Plug 'honza/vim-snippets'
Plug 'mattn/emmet-vim'

" Run tests with varying granularity
Plug 'janko-m/vim-test'

call plug#end()

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

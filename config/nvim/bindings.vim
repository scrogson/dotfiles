" Leader key
let mapleader=","
nnoremap <Space> <Nop>

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Better nav for omnicomplete
inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")

" Better escaping
nnoremap <silent> <C-c> <Esc>
inoremap jj <esc>

" Insert-mode hacks
inoremap II <esc>I
inoremap AA <esc>A
inoremap OO <esc>O

" Better search
nnoremap / /\v
vnoremap / /\v

" TAB in general mode will move to text buffer
nnoremap <silent> <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <silent> <S-TAB> :bprevious<CR>

" <TAB>: completion.
inoremap <silent> <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" Terminal window navigation
"tnoremap <C-h> <C-\><C-N><C-w>h
"tnoremap <C-j> <C-\><C-N><C-w>j
"tnoremap <C-k> <C-\><C-N><C-w>k
"tnoremap <C-l> <C-\><C-N><C-w>l
"inoremap <C-h> <C-\><C-N><C-w>h
"inoremap <C-j> <C-\><C-N><C-w>j
"inoremap <C-k> <C-\><C-N><C-w>k
"inoremap <C-l> <C-\><C-N><C-w>l
"tnoremap <Esc> <C-\><C-n>

" Use alt + hjkl to resize windows
nnoremap <silent> <M-j>    :resize -2<CR>
nnoremap <silent> <M-k>    :resize +2<CR>
nnoremap <silent> <M-h>    :vertical resize -2<CR>
nnoremap <silent> <M-l>    :vertical resize +2<CR>

map <leader>f :GFiles --exclude-standard --others --cached<cr>
map <leader>b :Buffers<cr>

" open init.vim
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

" Stop highlighting
map <leader><space> :noh<cr>

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

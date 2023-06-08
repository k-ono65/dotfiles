call denite#custom#var('ghq', 'command',
  \ ['ghq', 'list', '--full-path', '--vcs', 'git'])
" ghq grep
nnoremap <silent>,gh :<C-u>Denite ghq<CR>

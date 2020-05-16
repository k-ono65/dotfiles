" vim:et:sw=2:ts=2

" Plugin configuration like the code written in vimrc.
" This configuration is executed *before* a plugin is loaded.
function! s:on_load_pre()
  nmap <silent> ,f :<C-u>Denite file/rec<CR>
  nmap <silent> ,g :<C-u>Denite grep<CR>
  nmap <silent> ,t :<C-u>Denite file/type<CR>
  nmap <silent> ,b :<C-u>Denite buffer<CR>
  nmap <silent> ,l :<C-u>Denite line<CR>

  autocmd FileType denite call s:denite_my_settings()
  function! s:denite_my_settings() abort
    nnoremap <silent><buffer><expr> <CR>
          \ denite#do_map('do_action')
    nnoremap <silent><buffer><expr> d
          \ denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> p
          \ denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q
          \ denite#do_map('quit')
    nnoremap <silent><buffer><expr> i
          \ denite#do_map('open_filter_buffer')
    nnoremap <silent><buffer><expr> <Space>
          \ denite#do_map('toggle_select').'j'
  endfunction 

  autocmd FileType denite-filter call s:denite_filter_my_settings()
  function! s:denite_filter_my_settings() abort
    inoremap <silent><buffer><expr> <C-j> denite#do_map('toggle_select')
    inoremap <silent><buffer><expr> <C-k> denite#do_map('move_up_path')
    imap <silent><buffer><expr> <C-o> <Plug>(denite_filter_quit)
    inoremap <silent><buffer><expr> <C-c> denite#do_map('quit')
    nnoremap <silent><buffer><expr> <C-c> denite#do_map('quit')
  endfunction
endfunction

" Plugin configuration like the code written in vimrc.
" This configuration is executed *after* a plugin is loaded.
function! s:on_load_post()
  call denite#custom#var('file/rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
  call denite#custom#var('grep', 'command', ['ag'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'default_opts', ['--follow', '--no-group', '--no-color'])
  call denite#custom#kind('file', 'default_action', 'split')
  if has('nvim')
    let s:denite_win_width_percent = 0.85
    let s:denite_win_height_percent = 0.7
    let s:denite_default_options = {
          \ 'split': 'floating',
          \ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
          \ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
          \ 'winheight': float2nr(&lines * s:denite_win_height_percent),
          \ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
          \ 'highlight_filter_background': 'DeniteFilter',
          \ 'prompt': '$ ',
          \ 'start_filter': v:true,
          \ }
    let s:denite_option_array = []
    for [key, value] in items(s:denite_default_options)
      call add(s:denite_option_array, '-'.key.'='.value)
    endfor
  else
    let s:denite_default_options = {
          \ 'start_filter': v:true,
          \ }
  endif
  call denite#custom#option('default', s:denite_default_options)

  function! g:GetVisualWord() abort
    let word = getline("'<")[getpos("'<")[2] - 1:getpos("'>")[2] - 1]
    return word
  endfunction

  function! g:GetVisualWordEscape() abort
    let word = substitute(GetVisualWord(), '\\', '\\\\', 'g')
    let word = substitute(word, '[.?*+^$|()[\]]', '\\\0', 'g')
    return word
  endfunction

  xnoremap <silent> ,g :Denite grep:::`GetVisualWordEscape()`<CR>
endfunction

" This function determines when a plugin is loaded.
"
" Possible values are:
" * 'start' (a plugin will be loaded at VimEnter event)
" * 'filetype=<filetypes>' (a plugin will be loaded at FileType event)
" * 'excmd=<excmds>' (a plugin will be loaded at CmdUndefined event)
" <filetypes> and <excmds> can be multiple values separated by comma.
"
" This function must contain 'return "<str>"' code.
" (the argument of :return must be string literal)
function! s:loaded_on()
  return 'start'
endfunction

" Dependencies of this plugin.
" The specified dependencies are loaded after this plugin is loaded.
"
" This function must contain 'return [<repos>, ...]' code.
" (the argument of :return must be list literal, and the elements are string)
" e.g. return ['github.com/tyru/open-browser.vim']
function! s:depends()
  return []
endfunction

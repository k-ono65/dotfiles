if exists('g:loaded_volt_system_bundled_plugconf')
  finish
endif
let g:loaded_volt_system_bundled_plugconf = 1

" github.com/Shougo/denite.nvim
function! s:on_load_pre_1()
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

" github.com/Shougo/denite.nvim
function! s:on_load_post_1()
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

function! s:denite_filter_my_settings() abort
    inoremap <silent><buffer><expr> <C-j> denite#do_map('toggle_select')
    inoremap <silent><buffer><expr> <C-k> denite#do_map('move_up_path')
    imap <silent><buffer><expr> <C-o> <Plug>(denite_filter_quit)
    inoremap <silent><buffer><expr> <C-c> denite#do_map('quit')
    nnoremap <silent><buffer><expr> <C-c> denite#do_map('quit')
  endfunction

function! g:GetVisualWord() abort
    let word = getline("'<")[getpos("'<")[2] - 1:getpos("'>")[2] - 1]
    return word
  endfunction

function! g:GetVisualWordEscape() abort
    let word = substitute(GetVisualWord(), '\\', '\\\\', 'g')
    let word = substitute(word, '[.?*+^$|()[\]]', '\\\0', 'g')
    return word
  endfunction

" github.com/prabirshrestha/vim-lsp
function! s:on_load_pre_15()
  let g:lsp_highlight_references_enabled = 0
  let g:lsp_signature_help_enabled = 0
  let g:lsp_semantic_enabled = 0
  let g:lsp_log_file = expand('~/vim-lsp.log')
  let g:lsp_diagnostics_enabled = 1
  let g:lsp_diagnotics_float_cursor = 0
  let g:lsp_diagnostics_echo_cursor = 1
  let g:asyncomplete_auto_popup = 1
  let g:asyncomplete_popup_delay = 200
  let g:lsp_text_edit_enabled = 1

  function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> <C-]> <plug>(lsp-definition)
  endfunction

  augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END
endfunction

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    nmap <buffer> <C-]> <plug>(lsp-definition)
  endfunction

" github.com/sainnhe/gruvbox-material
function! s:on_load_post_17()
  set termguicolors
  set background=dark
  let g:gruvbox_material_background = 'soft'
  autocmd VimEnter * colorscheme gruvbox-material
endfunction

" github.com/tyru/open-browser.vim
function! s:on_load_post_21()
  nmap <Leader>b <Plug>(openbrowser-smart-search)
  vmap <Leader>b <Plug>(openbrowser-smart-search)
endfunction

augroup volt-bundled-plugconf
  autocmd!
  call s:on_load_pre_1() | packadd github.com_Shougo_denite.nvim | call s:on_load_post_1()
  packadd github.com_Shougo_vimproc
  packadd github.com_airblade_vim-gitgutter
  packadd github.com_hashivim_vim-terraform
  packadd github.com_hrsh7th_vim-vsnip
  packadd github.com_hrsh7th_vim-vsnip-integ
  packadd github.com_junegunn_fzf
  packadd github.com_junegunn_fzf.vim
  packadd github.com_mattn_vim-goimports
  packadd github.com_mattn_vim-lsp-icons
  packadd github.com_mattn_vim-lsp-settings
  packadd github.com_prabirshrestha_async.vim
  packadd github.com_prabirshrestha_asyncomplete-lsp.vim
  packadd github.com_prabirshrestha_asyncomplete.vim
  call s:on_load_pre_15() | packadd github.com_prabirshrestha_vim-lsp
  packadd github.com_rking_ag.vim
  packadd github.com_sainnhe_gruvbox-material | call s:on_load_post_17()
  packadd github.com_scrooloose_nerdtree
  packadd github.com_simeji_winresizer
  packadd github.com_skanehira_translate.vim
  packadd github.com_tyru_open-browser.vim | call s:on_load_post_21()
augroup END
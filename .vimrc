" default settings {{{

"--------------------------
" display settings
"--------------------------
set number				"行番号を表示する
set shellslash			"Windowsでもファイル名を/区切りにする
set shiftwidth=4		"自動インデントに使われる空白の数
set shortmess+=a		"ファイル関連のメッセージのフォーマット
set shortmess+=I		"同上"
set showbreak=>			"折り返された行の先頭に表示する文字列
set showcmd				"入力中のコマンドが表示する
set showmatch			"対応する括弧を強調表示
set laststatus=2		"常にステータス行を表示
set cmdheight=2			"メッセージ表示欄を2行確保
set helpheight=999		"ヘルプを画面いっぱいに開く
set switchbuf=usetab	"バッファを切り替えるときの動作を調節する。
set showtabline=2		"タブラベルを常に表示する"

"--------------------------
" cursol settings
"--------------------------
set scrolloff=4			" 上下4行の視界を確保
set sidescrolloff=16	" 左右スクロール時の視界を確保
set backspace=indent,eol,start

"--------------------------
" indent settings
"--------------------------
set expandtab
set tabstop=4			"タブの空白文字数
set softtabstop=4		"タブ入力時の空白文字数
set shiftwidth=4		"自動インデントでずれる幅
set autoindent			"改行時に前の行のインデントを継続する
set smartindent			"改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smarttab			"行頭の余白内で Tab を打ち込むと、'shiftwidth' の数だけインデントする

filetype plugin on      "filetypeによって設定を変える
filetype indent on      "filetypeによって設定を変える
"--------------------------
" search settings
"--------------------------
set hlsearch			"検索文字列をハイライトする
set noswapfile			"スワップファイルを作成しない
set incsearch			"インクリメンタルサーチを行う
set ignorecase			"大文字と小文字を区別しない
set smartcase			"検索文字列に応じて大文字と小文字を区別する
set wrapscan			"最後尾まで検索を終えたら次の検索で先頭に移る
set gdefault			"置換の時 g オプションをデフォルトで有効にする

"--------------------------
" handling file settings
"--------------------------
set autoread			"外部でファイルに変更がされた場合は読みなおす
set nobackup			"ファイル保存時にバックアップファイルを作らない
set noswapfile			"ファイル編集中にスワップファイルを作らない
set noundofile          "undoファイルを作らない

"--------------------------
" cmd line settings
"--------------------------
set history=10000		"コマンドラインの履歴を10000件保存する


"--------------------------
" leader setting
"--------------------------
let mapleader = "\<Space>"  "スペースをleaderとして登録する

" }}}

" unite.vim {{{
"--------------------------
" The prefix key.
"--------------------------
nnoremap    [unite]   <Nop>
nmap    <Leader>f [unite]

"--------------------------
" unite.vim keymap
"--------------------------
nnoremap [unite]u  :<C-u>Unite -no-split<Space>
nnoremap <silent> [unite]f :<C-u>Unite<Space>buffer<CR>
nnoremap <silent> [unite]b :<C-u>Unite<Space>bookmark<CR>
nnoremap <silent> [unite]m :<C-u>Unite<Space>file_mru<CR>
nnoremap <silent> [unite]r :<C-u>UniteWithBufferDir file<CR>
nnoremap <silent> ,vr :UniteResume<CR>

"--------------------------
" vinarise
"--------------------------
let g:vinarise_enable_auto_detect = 1

"--------------------------
" unite-build map
"--------------------------
nnoremap <silent> ,vb :Unite build<CR>
nnoremap <silent> ,vcb :Unite build:!<CR>
nnoremap <silent> ,vch :UniteBuildClearHighlight<CR>

"" }}}

"--------------------------
" nerdtree map
"--------------------------
nnoremap <silent><Leader>e :NERDTreeToggle<CR>

" tab setting {{{
nnoremap [TABCMD]  <nop>
nmap     <leader>t [TABCMD]

nnoremap <silent> [TABCMD]H :<c-u>tabfirst<cr>
nnoremap <silent> [TABCMD]L :<c-u>tablast<cr>
nnoremap <silent> [TABCMD]l :<c-u>tabnext<cr>
nnoremap <silent> [TABCMD]h :<c-u>tabprevious<cr>
nnoremap <silent> [TABCMD]n :<c-u>tabedit<cr>
nnoremap <silent> [TABCMD]q :<c-u>tabclose<cr>
nnoremap <silent> [TABCMD]o :<c-u>tabonly<cr>
nnoremap <silent> [TABCMD]s :<c-u>tabs<cr>
" }}}

" dein settings {{{
"--------------------------
" vi compatible
"--------------------------
if &compatible
  set nocompatible
endif

"--------------------------
" dein.vim directory
"--------------------------
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

"--------------------------
" dein install
"--------------------------
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  "--------------------------
  " manage plugin files
  "--------------------------
  let s:toml = expand('~/.dein.toml')
  let s:lazy_toml = expand('~/.dein_lazy.toml')
  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

"}}}

" neocomplete & neosnippet setting {{{

"--------------------------
" neosnippet
"--------------------------
smap <silent><expr><TAB>  neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
nmap <silent><expr><TAB>  neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
imap <silent><expr><TAB>  neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
imap <silent><expr><C-x>  MyNeoCompleteCr()
imap <silent><expr><CR>   MyNeoCompleteCr()
nmap <silent><S-TAB> <ESC>a<C-r>=neosnippet#commands#_clear_markers()<CR>
:"inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"

let g:neosnippet#data_directory                = $HOME . '/.vim/neosnippet.vim'
let g:neosnippet#disable_runtime_snippets      = {'_' : 1}
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#snippets_directory            = $HOME . '/.vim/snippets'
function! MyNeoCompleteCr() abort "{{{
    if pumvisible() is# 0
        return "\<CR>X\<C-h>"
    elseif neosnippet#expandable_or_jumpable()
        return "\<Plug>(neosnippet_expand_or_jump)"
    endif
    return "\<Left>\<Right>"
endfunction "}}}

"--------------------------
" neocomplete
"--------------------------
let g:neocomplete#auto_completion_start_length = 3
let g:neocomplete#data_directory               = $HOME .'/.vim/neocomplete.vim'
let g:neocomplete#delimiter_patterns           = {
\    'javascript': ['.'],
\    'php':        ['->', '::', '\'],
\    'ruby':       ['::']
\}
let g:neocomplete#enable_at_startup         = 1
let g:neocomplete#enable_auto_close_preview = 1
let g:neocomplete#enable_auto_delimiter     = 1
let g:neocomplete#enable_auto_select        = 0
let g:neocomplete#enable_fuzzy_completion   = 0
let g:neocomplete#enable_smart_case         = 1
let g:neocomplete#keyword_patterns          = {'_': '\h\w*'}
let g:neocomplete#lock_buffer_name_pattern  = '\.log\|.*quickrun.*\|.jax'
let g:neocomplete#max_keyword_width         = 30
let g:neocomplete#max_list                  = 8
let g:neocomplete#min_keyword_length        = 3
let g:neocomplete#sources                   = {
\    '_':          ['neosnippet', 'file',               'buffer'],
\    'css':        ['neosnippet',         'dictionary', 'buffer'],
\    'html':       ['neosnippet', 'file', 'dictionary', 'buffer'],
\    'javascript': ['neosnippet', 'file', 'dictionary', 'buffer'],
\    'php':        ['neosnippet', 'file', 'dictionary', 'buffer']
\}
let g:neocomplete#sources#buffer#cache_limit_size  = 50000
let g:neocomplete#sources#buffer#disabled_pattern  = '\.log\|\.jax'
let g:neocomplete#sources#buffer#max_keyword_width = 30
let g:neocomplete#sources#dictionary#dictionaries  = {
\    '_':          '',
\    'css':        $HOME . '/.vim/dict/css.dict',
\    'html':       $HOME . '/.vim/dict/html.dict',
\    'javascript': $HOME . '/.vim/dict/javascript.dict',
\    'php':        $HOME . '/.vim/dict/php.dict'
\}
let g:neocomplete#use_vimproc = 1

"}}}

"--------------------------
" colorscheme
"--------------------------
colorscheme molokai
syntax on

"--------------------------
" ft setting
"-------------------------
autocmd BufRead,BufNewFile *.json setfiletype json

"--------------------------
" tags
"--------------------------
"nnoremap <C-]> g<C-]>
"au BufNewFile,BufRead *.php set tags+=$HOME/.vim/tags/global.tags
"source ~/.vim/vimrc.local

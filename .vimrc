" default settings {{{

"--------------------------
" display settings
"--------------------------
set number				"行番号を表示する
set shellslash			"Windowsでもファイル名を/区切りにする
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
set cursorline
set cursorcolumn

"--------------------------
" indent settings
"--------------------------
set expandtab
set tabstop=2			"タブの空白文字数
set softtabstop=2		"タブ入力時の空白文字数
set shiftwidth=2		"自動インデントでずれる幅
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
" colorscheme
"--------------------------
syntax on

set termguicolors
if has('nvim')
  set pumblend=10
endif

"--------------------------
" terminal setting
"--------------------------
command! -nargs=* T split | terminal <args>
command! -nargs=* VT vsplit | terminal <args>

" }}

let g:python2_host_prog = system('echo -n $(which python2)')
let g:python3_host_prog = system('echo -n $(which python3)')

call map(sort(split(globpath(&runtimepath,'_config/*.vim'))),{->[execute('exec "so" v:val')]})

let s:plugin_vimrc_dir = '$HOME/.config/nvim/_config/plugins'
function! RequirePlugin(path)
  execute "source" s:plugin_vimrc_dir . '/' . a:path
endfunction
"--------------------------
" dein
"-------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
let $CACHE = expand('~/.cache')
if !isdirectory($CACHE)
  call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dein_dir = fnamemodify('dein.vim', ':p')
  if !isdirectory(s:dein_dir)
    let s:dein_dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !isdirectory(s:dein_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
    endif
  endif
  execute 'set runtimepath^=' .. substitute(
        \ fnamemodify(s:dein_dir, ':p') , '[/\\]$', '', '')
endif

" Required:
if dein#min#load_state($HOME . '/.cache/dein')
  call dein#begin($HOME . '/.cache/dein')

  let s:toml_dir  = $HOME . '/.config/nvim/dein/toml'
  let s:toml      = s:toml_dir . '/dein.toml'
  let s:lazy_toml = s:toml_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml, {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

"--------------------------
" ft setting
"-------------------------
autocmd BufRead,BufNewFile *.json setfiletype json
runtime! ftplugin/man.vim


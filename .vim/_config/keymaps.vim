"--------------------------
" key map
"--------------------------
nnoremap <S-h> 0
nnoremap <S-l> $
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :<C-u>cfirst<CR>
nnoremap ]Q :<C-u>clast<CR>

"--------------------------
" leader setting
"--------------------------
let mapleader = "\<Space>"  "スペースをleaderとして登録する

"--------------------------
" nerdtree map
"--------------------------
nnoremap <silent><Leader>e :NERDTreeToggle<CR>

"-------------------------
" fzf
"-------------------------
nnoremap <silent><Leader>k :Ag<CR>

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


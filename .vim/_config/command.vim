if executable('jq')
  function! s:jq(...)
    execute '%!jq' (a:0 == 0 ? '.' : a:1)
  endfunction
  command! -bar -nargs=? Jq  call s:jq(<f-args>)
endif

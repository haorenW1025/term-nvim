function! termnvim#term_kill(job) abort
    call chansend(a:job, "\<c-c>")
endfunction

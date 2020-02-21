if exists('g:loaded_term') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 TermToggle lua require'term'.term_toggle()
command! -nargs=1 TermSend lua require'term'.term_send(<f-args>)
command! -nargs=0 TermKill lua require'term'.term_kill()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_term = 1

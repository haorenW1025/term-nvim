if exists('g:loaded_term') | finish | endif

let s:save_cpo = &cpo
set cpo&vim

if ! exists('g:term_default_height')
    " disable autoclose by defualt
    let g:term_default_height = 15
endif

if ! exists('g:term_focus_height')
    " disable autoclose by defualt
    let g:term_focus_height = 80
endif

if ! exists('g:term_terminal_mode_toggle')
    let g:term_terminal_mode_toggle = '<c-t>'
endif
command! -nargs=0 TermToggle lua require'term'.term_toggle()
command! -nargs=1 TermSend lua require'term'.term_send(<f-args>)
command! -nargs=0 TermKill lua require'term'.term_kill()
command! -nargs=0 TermFocus lua require'term'.term_focus()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_term = 1

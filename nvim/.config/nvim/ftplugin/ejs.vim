" EJS filetype plugin
" Aggressive syntax highlighting maintenance

" Force syntax highlighting to stay active
setlocal synmaxcol=0
setlocal redrawtime=10000

" Disable problematic folding
setlocal foldmethod=manual
setlocal foldlevel=99

" Comment strings for EJS
setlocal commentstring=<%#\ %s\ %>

" Auto-refresh syntax on various events
augroup EJSSyntax
  autocmd! * <buffer>
  autocmd BufEnter <buffer> syntax sync fromstart
  autocmd InsertLeave <buffer> syntax sync fromstart | redraw
  autocmd CursorHold <buffer> if line('.') > 100 | syntax sync fromstart | endif
augroup END

" Manual syntax refresh command
command! -buffer EjsRefresh syntax sync fromstart | redraw!

" Force initial sync
syntax sync fromstart
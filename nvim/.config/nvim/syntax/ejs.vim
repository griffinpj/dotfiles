" Vim syntax file
" Language: EJS (Embedded JavaScript)
" Maintainer: Generated for Neovim config

if exists("b:current_syntax")
  finish
endif

" Load HTML syntax first
runtime! syntax/html.vim
unlet! b:current_syntax

" EJS regions
syn region ejsScriptlet matchgroup=ejsDelim start=+<%+ end=+%>+ contains=@htmlJavaScript keepend
syn region ejsExpression matchgroup=ejsDelim start=+<%=+ end=+%>+ contains=@htmlJavaScript keepend  
syn region ejsEscape matchgroup=ejsDelim start=+<%-+ end=+%>+ contains=@htmlJavaScript keepend
syn region ejsComment matchgroup=ejsDelim start=+<%#+ end=+%>+ contains=@htmlJavaScript keepend

" Highlighting
hi def link ejsDelim PreProc
hi def link ejsComment Comment

" Include JavaScript highlighting in EJS blocks
syn include @ejsJavaScript syntax/javascript.vim
syn region ejsScriptlet matchgroup=ejsDelim start=+<%+ end=+%>+ contains=@ejsJavaScript keepend
syn region ejsExpression matchgroup=ejsDelim start=+<%=+ end=+%>+ contains=@ejsJavaScript keepend  
syn region ejsEscape matchgroup=ejsDelim start=+<%-+ end=+%>+ contains=@ejsJavaScript keepend

let b:current_syntax = "ejs"
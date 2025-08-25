" Vim syntax file
" Language: EJS (Embedded JavaScript)
" Maintainer: Generated for Neovim config

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Load HTML syntax as base - this gives us all HTML highlighting
runtime! syntax/html.vim

" Include JavaScript syntax for EJS blocks
syn include @ejsJS syntax/javascript.vim
unlet! b:current_syntax

" EJS delimiter highlighting
hi def link ejsDelim PreProc

" EJS scriptlet blocks (<%...%>) - JavaScript code
syn region ejsScriptlet matchgroup=ejsDelim start=/<%\ze[^-=#]/ end=/%>/ contains=@ejsJS keepend

" EJS expression blocks (<%=...%>) - JavaScript expressions  
syn region ejsExpression matchgroup=ejsDelim start=/<%=/ end=/%>/ contains=@ejsJS keepend

" EJS escaped expression blocks (<%-...%>) - JavaScript expressions (HTML-escaped)
syn region ejsEscape matchgroup=ejsDelim start=/<%-/ end=/%>/ contains=@ejsJS keepend

" EJS comment blocks (<%#...%>) - Comments
syn region ejsComment matchgroup=ejsDelim start=/<%#/ end=/%>/ keepend
hi def link ejsComment Comment

" Synchronization - keep it simple and reliable
syn sync clear
syn sync match ejsSync grouphere NONE /<%/
syn sync match ejsSync groupthere NONE /%>/
syn sync minlines=50
syn sync maxlines=200

let &cpo = s:cpo_save
unlet s:cpo_save

let b:current_syntax = "ejs"
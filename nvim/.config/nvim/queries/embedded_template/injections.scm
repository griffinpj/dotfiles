; Language injection for EJS templates
; Inject JavaScript into code blocks
((code) @injection.content
  (#set! injection.language "javascript"))

; Inject HTML into content blocks  
((content) @injection.content
  (#set! injection.language "html"))
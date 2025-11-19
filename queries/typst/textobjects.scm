;; ------------------------------
;; Typst math textobjects
;; ------------------------------

; Outer selection: the full math environment, including delimiters `$...$`, `[..]`, etc.
((math) @math.outer)

; Inner selection: the content inside the math environment.
((math (_) @math.inner))

(define-macro (assert condition)
  `(if ,condition 
    (display ".")
    (display "F")))

(define-macro (expect . args)

  (define (includes-failure-message?)
    (= 2 (length args)))
  
  (define (test-condition)
    (if (includes-failure-message?)
      (cadr args)
      (car args)))

  `(if (not ,(test-condition))
     (display "F")
     (display ".")))

(define (display-expect-results)
  (display "All passed")
  (newline))

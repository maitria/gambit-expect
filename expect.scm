(define-macro (expect . args)

  (define (includes-failure-message)
    (= 2 (length args)))
  
  (define (failure-message)
    (if (includes-failure-message)
      (test-condition)
      "a generic failure message"))

  (define (test-condition)
    (if (includes-failure-message)
      (cadr args)
      (car args)))

  (if (includes-failure-message) 
    (let ((message (car args))
          (test-expression (cadr args)))
      `(if (not ,(test-condition))
	 (begin
	   (display "X")
	   (newline)
	   (display "TEST FAILED: ")
	   (display ,message))
	(display ".")))
    `(if (not ,(test-condition))
       (begin
	 (display "X")
         (display "TEST FAILED: ")
         (display ',(car args))))))

(define (display-expect-results)
  (display "All passed")
  (newline))

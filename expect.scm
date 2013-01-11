(define-macro (expect . args)

  (define (includes-failure-message)
    (= 2 (length args)))
  
  (define (test-condition)
    (if (includes-failure-message)
      (cadr args)
      (car args)))

  (define (failure-message)
    (car args))

;; (define (store-verbose-failure-message))

  (if (includes-failure-message) 
    `(if (not ,(test-condition))
       (begin
	 (display "X")
	 (newline)
	 (display "TEST FAILED: ")
	 (display ,(failure-message)))
      (display "."))
    `(if (not ,(test-condition))
       (begin
         (display "TEST FAILED: ")
         (display ',(car args))
	 (display "X")))))

(define (display-expect-results)
  (display "All passed")
  (newline))

(define expect:*example-count* 0)
(define expect:*failure-count* 0)

(define-macro (expect . args)

  (define (includes-failure-message?)
    (= 2 (length args)))
  
  (define (test-condition)
    (if (includes-failure-message?)
      (cadr args)
      (car args)))

  `(begin
     (set! expect:*example-count* (+ 1 expect:*example-count*))
     (if (not ,(test-condition))
       (begin
	 (set! expect:*failure-count* (+ 1 expect:*failure-count*))
         (display "F"))
       (display "."))))

(define (expect:display-results)
  (cond
    ((= 0 expect:*example-count*)
     #f)
    (else
     (newline)
     (newline)
     (display expect:*example-count*)
     (display " examples, ")
     (display expect:*failure-count*)
     (display " failures")
     (newline))))

(let ((old-##exit ##exit))
  (set! ##exit (lambda args
		 (expect:display-results)
		 (old-##exit args))))

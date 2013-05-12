(define expect:*example-count* 0)
(define expect:*failure-count* 0)
(define expect:*failures* '())

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
         (set! expect:*failures* 
           (append expect:*failures* (list ',(test-condition))))
	 (set! expect:*failure-count* (+ 1 expect:*failure-count*))
         (display "F"))
       (display "."))))

(define (expect:display-one-failure test-condition)
  (display "FAILED: ")
  (write test-condition)
  (newline))

(define (expect:display-failed-test) 
  (for-each expect:display-one-failure expect:*failures*))

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
     (newline)
     (if (> expect:*failure-count* 0)
       (begin
         (newline)
         (expect:display-failed-test))
         ))))

(define (expect:override-exit-to-display-results)
  (let ((default-exit ##exit))
    (set! ##exit (lambda (#!optional (exit-code 0))
                       (expect:display-results)
                       (default-exit exit-code)))))
  
(expect:override-exit-to-display-results)

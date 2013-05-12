(define expect:*example-count* 0)
(define expect:*failures* '())
(define-type expect-failure
  (test-condition read-only:)
  (message read-only:))

(define-macro (expect . args)

  (define (includes-failure-message?)
    (= 2 (length args)))
  
  (define (test-condition)
    (if (includes-failure-message?)
      (cadr args)
      (car args)))

  (define (message)
    (if (includes-failure-message?)
      (car args)
      #f))

  `(begin
     (set! expect:*example-count* (+ 1 expect:*example-count*))
     (if (not ,(test-condition))
       (let ((failure (make-expect-failure ',(test-condition) ',(message))))
         (set! expect:*failures* (append expect:*failures* (list failure)))
         (display "F"))
       (display "."))))

(define (expect:display-failure failure)
  (display "FAILED: ")
  (if (expect-failure-message failure)
    (begin
      (display (expect-failure-message failure))
      (display " ")))
  (write (expect-failure-test-condition failure))
  (newline))

(define (expect:display-results)
  (cond
    ((= 0 expect:*example-count*)
     #f)
    (else
     (newline)
     (newline)
     (display expect:*example-count*)
     (display " examples, ")
     (display (length expect:*failures*))
     (display " failures")
     (newline)
     (if (> (length expect:*failures*) 0)
       (begin
         (newline)
         (for-each expect:display-failure expect:*failures*))))))

(define (expect:override-exit-to-display-results)
  (let ((default-exit ##exit))
    (set! ##exit (lambda (#!optional (exit-code 0))
                       (expect:display-results)
                       (default-exit exit-code)))))
  
(expect:override-exit-to-display-results)

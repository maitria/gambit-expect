;; we made manual unit tests. it worked.
;; hoping we can see all the testfiles in the tests directory
;; ' is quote, always literal. ` is quasi-quote, evaluate , things inside.

(define-macro (assert condition)
  `(if ,condition 
    (display ".")
    (display "F"))
  )

(define (get-all-the-tests)
  (read-all (open-directory "tests/")))

(define (expected-results-filename test-filename)
  (define truncated-filename (substring test-filename 0 (- (string-length test-filename) 3)))
  (string-append truncated-filename "txt"))

(assert (string=? (expected-results-filename "tests/no-tests.scm") "tests/no-tests.txt"))
(assert (list? (get-all-the-tests)))
(assert (not (member "no-tests.scm" (get-all-the-tests))))

(newline)
(display "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
(newline)
(display "I'm done running.")
(newline)

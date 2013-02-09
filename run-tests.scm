(define-macro (assert condition)
  `(if ,condition 
    (display ".")
    (display "F"))
  )

(define (get-all-the-tests)
  (get-tests-from (get-everything)))

(define (is-a-test? filename)
  (string=? "scm" (substring filename (- (string-length filename) 3) (string-length filename))))

(define (get-tests-from list-of-files)
  (define test-files '())
  (let loop ((remaining-files list-of-files))
    (if (not (null? remaining-files))
      (let ((this-file (car remaining-files)))
	(if (is-a-test? this-file) (set! test-files (cons this-file test-files)))
      (loop (cdr remaining-files))))
      )
  test-files
  )

(define (get-everything)
  (read-all (open-directory "tests/")))

(define (expected-results-filename test-filename)
  (define truncated-filename (substring test-filename 0 (- (string-length test-filename) 3)))
  (string-append truncated-filename "txt"))

(assert (string=? (expected-results-filename "tests/no-tests.scm") "tests/no-tests.txt"))
(assert (list? (get-all-the-tests)))
(assert (not (member "no-tests.txt" (get-all-the-tests))))

(newline)
(display "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
(newline)
(display "I'm done running.")
(newline)

(load "utilities.scm")

(define (get-tests-from list-of-files)
  (collect-tests-from list-of-files))

(define (collect-tests-from files)
  (define test-files '())
  (define (pick-out-test-files file)
    (if is-a-test? files 
      (set! test-files (cons file test-files))))
  (for-each pick-out-test-files files)
  test-files)

(define (get-all-the-tests)
  (get-tests-from (get-everything)))

(define (is-a-test? filename)
  (string=? "scm" (substring filename (- (string-length filename) 3) (string-length filename))))

(define (have-any? stuff)
  (not (null? stuff)))

(define (get-everything)
  (read-all (open-directory "test/")))

(define-macro (assert condition)
  `(if ,condition 
    (display ".")
    (display "F")))

(define (filename-with-expected-output-for test-filename)
  (define truncated-filename (substring test-filename 0 (- (string-length test-filename) 3)))
  (string-append truncated-filename "output"))

(define (captured-output-for command)
  (with-input-from-process command read-all-the-lines))
 

;; filename for expected output is the same but ends in output
(assert (string=? (filename-with-expected-output-for "tests/no-tests.scm") "tests/no-tests.output"))
;; get-all-the-tests is a list
(assert (list? (get-all-the-tests)))
;; get-all-the-tests doesn't return files ending in output
(assert (not (member "no-tests.output" (get-all-the-tests))))
;; captured output is a string
(assert (string? (captured-output-for "ls")))
;; captured output for ls contains 'test'
(assert (string-contains? (captured-output-for "ls") "test"))
(assert (not (string-contains? (captured-output-for "ls") "florb")))

(newline)
(display "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
(newline)

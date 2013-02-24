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

(define (captured-output command)
  (with-input-from-process command read-all-the-lines))
 
(define (read-all-the-lines)
  (define captured-lines "")
  (let read-a-line ()
    (define this-line (read-line))
    (cond 
      ((not (eof-object? this-line))
        (set! captured-lines (string-append captured-lines this-line))
        (read-a-line))
      (else captured-lines))))

(define (string-contains? haystack needle)
  (define text-found? #f)
  (define (inspect letter)
    (let the-word ((index 0)) 
      (define (potential-hit)
        (substring haystack index (+ index (string-length needle))))
      (cond
        ((> index (- (string-length haystack) (string-length needle)))
            #f)
        ((string=? (potential-hit) needle)
          (set! text-found? #t))  
        (else 
          (the-word (+ index 1))
        ))))
  (for-each inspect (string->list haystack))
 text-found?) 

;; filename for expected output is the same but ends in output
(assert (string=? (filename-with-expected-output-for "tests/no-tests.scm") "tests/no-tests.output"))
;; get-all-the-tests is a list
(assert (list? (get-all-the-tests)))
;; get-all-the-tests doesn't return files ending in output
(assert (not (member "no-tests.output" (get-all-the-tests))))
;; captured output is a string
(assert (string? (captured-output "ls")))
;; captured output for ls contains 'test'
(assert (string-contains? (captured-output "ls") "test"))
(assert (not (string-contains? (captured-output "ls") "florb")))

(newline)
(display "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-")
(newline)

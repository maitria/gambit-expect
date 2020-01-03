(define *temporary-scheme-file* "./tmp/test.scm")

(define (read-all-as-string port)
  (define s (make-string 4096))
  (let loop ((c (read-char port))
             (i 0))
    (cond
      ((eof-object? c)
       (substring s 0 i))
      (else
       (if (= i (string-length s))
         (let ((ns (make-string (* 2 (string-length s)))))
           (substring-move! s 0 i ns 0)
           (set! s ns)))
       (string-set! s i c)
       (loop (read-char port) (+ i 1))))))

(define-macro (expect-file #!key containing-code to-match exits-with)
  `(begin
     (with-output-to-file *temporary-scheme-file*
        (lambda ()
          (for-each write ,containing-code)))
     (let* ((result (call-with-input-process
                      (list path: "gsi" arguments: (list *temporary-scheme-file*))
                      (lambda (port)
                        (cons (read-all-as-string port)
                              (process-status port)))))
            (actual-output (car result))
            (actual-exit-code (/ (cdr result) 256)))
       (delete-file *temporary-scheme-file*)
       (if (not (string=? actual-output ,to-match))
         (error (string-append
                  "Got bad output.\n"
                  "----- EXPECTED -----\n"
                  ,to-match
                  "-------- GOT -------\n"
                  actual-output
                  "===================\n")))
       (if (and (not (equal? #f ,exits-with))
                (not (eqv? actual-exit-code ,exits-with)))
         (error (string-append
                  "Got bad exit code.\n"
                  "EXPECTED: " (number->string ,exits-with) "\n"
                  "     GOT: " (number->string actual-exit-code) "\n"))))))

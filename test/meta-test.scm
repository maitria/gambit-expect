(define *temporary-scheme-file* "./tmp/test.scm")

(define (read-all-as-string)
  (define s (make-string 4096))
  (let loop ((c (read-char))
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
       (loop (read-char) (+ i 1))))))

(define-macro (expect-file #!key containing-code to-match)
  `(begin
     (with-output-to-file *temporary-scheme-file*
        (lambda ()
          (for-each write ,containing-code)))
     (let ((actual-output (with-input-from-process
                            (list path: "gsi" arguments: (list *temporary-scheme-file*))
                            read-all-as-string)))
       (delete-file *temporary-scheme-file*)
       (if (not (string=? actual-output ,to-match))
         (error (string-append
                  "Got bad output.\n"
                  "----- EXPECTED -----\n"
                  ,to-match
                  "-------- GOT -------\n"
                  actual-output
                  "===================\n"))))))

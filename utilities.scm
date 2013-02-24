(define (string-contains? haystack needle)
  (let dig-through ((start 0)) 
    (define (potential-hit)
      (substring haystack start (+ start (string-length needle))))
    (define gone-too-far? 
      (> start (- (string-length haystack) (string-length needle))))
    (define (found-it?) 
      (string=? (potential-hit) needle)) 
    (cond
      (gone-too-far? #f)
      ((found-it?) #t)  
      (else (dig-through (+ start 1))
      ))))

(define (read-all-the-lines)
  (define captured-lines "")
  (let read-a-line ()
    (define this-line (read-line))
    (cond 
      ((not (eof-object? this-line))
        (set! captured-lines (string-append captured-lines this-line))
        (read-a-line))
      (else captured-lines))))

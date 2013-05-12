(include "lib.scm")

(expect-file
  containing-code: '((include "../lib/expect.scm")
		     (expect (= 3 4))
		     (expect "this test should pass" (= 0 0))
		     (expect "this test should pass" (= 0 0)))
  to-match: #<<EOF
F..

3 examples, 1 failures

FAILED: (= 3 4)

EOF
)

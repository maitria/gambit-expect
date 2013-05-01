(include "lib.scm")

(expect-file
  containing-code: '((include "../lib/expect.scm")
		     (expect (= 1 1))
		     (expect (= 2 2))
		     (expect "this test should pass" (= 0 0))
		     (expect "this test should pass" (= 0 0)))
  to-match: #<<EOF
....

4 examples, 0 failures

EOF
)

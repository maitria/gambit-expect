(include "lib.scm")

(expect-file
  containing-code: '((include "../lib/expect.scm")
		     (expect (= 3 4))
		     (expect "this test should pass" (= 0 0))
		     (expect "this test should pass" (= 0 0))
                     (expect "this test should fail" (= 1 5)))
  to-match: #<<EOF
F..F

4 examples, 2 failures

FAILED: (= 3 4)
FAILED: this test should fail (= 1 5)

EOF
)

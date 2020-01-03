(include "meta-test.scm")

(expect-file
  containing-code: '((include "../lib/expect.scm")
                     (expect (= 3 4))
                     (expect "this test should pass" (= 0 0))
                     (expect "this test should pass" (= 0 0))
                     (expect "this test should fail" (= 1 5))
                     (expect (string=? "hello" "goodbye")))
  to-match: #<<EOF
F..FF

5 examples, 3 failures

FAILED: (= 3 4)
FAILED: this test should fail (= 1 5)
FAILED: (string=? "hello" "goodbye")

EOF
  exits-with: 3
)

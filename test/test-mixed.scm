(include "lib.scm")

(expect-file
  containing-code: '((include "../lib/expect.scm")
		     (expect (= 1 2))
		     (expect "this test should pass" (= 0 0))
		     (expect "this test should pass" (= 0 0))
		     (expect "this test should fail" (= 1 2)))
  to-match: "F..F")

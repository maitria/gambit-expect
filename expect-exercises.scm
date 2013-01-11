(include "expect.scm")
(expect "this test should fail" (= 1 2))
(expect "this test should pass" (= 0 0))

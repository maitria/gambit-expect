(include "meta-test.scm")

(expect-file
  containing-code: '((include "../lib/expect.scm"))
  to-match: "")

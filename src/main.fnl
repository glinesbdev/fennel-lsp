(with-open [f (assert (io.open :tests/fixtures/lexer-test.fnl :r))]
  (let [contents (f:read :*all)
        {: view} (require :fennel)
        {: begin} (require :lexer)]
    (print (view (begin contents 1 1 1 {})))))

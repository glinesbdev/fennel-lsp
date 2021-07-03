(local lexer (require :src.lexer))

(local expected-lexer-output [{:column 0 :line 1 :token "(" :type "LPAREN"}
 {:column 1 :line 1 :token "local" :type "KEYWORD"}
 {:column 7 :line 1 :token "core" :type "VARIABLE"}
 {:column 12 :line 1 :token "(" :type "LPAREN"}
 {:column 13 :line 1 :token "require" :type "FUNC"}
 {:column 21 :line 1 :token ":core" :type "FUNC"}
 {:column 26 :line 1 :token ")" :type "RPAREN"}
 {:column 27 :line 1 :token ")" :type "RPAREN"}
 {:column 0 :line 3 :token "(" :type "LPAREN"}
 {:column 1 :line 3 :token "local" :type "KEYWORD"}
 {:column 7 :line 3 :token "tbl" :type "VARIABLE"}
 {:column 11 :line 3 :token "[" :type "LBRACKET"}
 {:column 13 :line 3 :token "1" :type "NUMBER"}
 {:column 15 :line 3 :token "2" :type "NUMBER"}
 {:column 17 :line 3 :token "3" :type "NUMBER"}
 {:column 18 :line 3 :token ":hello" :type "VARIABLE"}
 {:column 24 :line 3 :token "]" :type "RBRACKET"}
 {:column 25 :line 3 :token ")" :type "RPAREN"}
 {:column 0 :line 5 :token "(" :type "LPAREN"}
 {:column 1 :line 5 :token "fn" :type "KEYWORD"}
 {:column 4 :line 5 :token "setup" :type "FUNC"}
 {:column 10 :line 5 :token "[" :type "LBRACKET"}
 {:column 11 :line 5 :token "player" :type "ARG"}
 {:column 17 :line 5 :token "]" :type "RBRACKET"}
 {:column 2
  :line 6
  :token "\"Setup the player with some basics\""
  :type "DOCSTRING"}
 {:column 2 :line 7 :token "(" :type "LPAREN"}
 {:column 3 :line 7 :token "give-tool" :type "FUNC"}
 {:column 13 :line 7 :token "player" :type "FUNC"}
 {:column 20 :line 7 :token ":torch" :type "FUNC"}
 {:column 26 :line 7 :token ")" :type "RPAREN"}
 {:column 2 :line 8 :token "(" :type "LPAREN"}
 {:column 3 :line 8 :token "give-tool" :type "FUNC"}
 {:column 13 :line 8 :token "player" :type "FUNC"}
 {:column 20 :line 8 :token ":map" :type "FUNC"}
 {:column 24 :line 8 :token ")" :type "RPAREN"}
 {:column 2 :line 9 :token "(" :type "LPAREN"}
 {:column 3 :line 9 :token "give-tool" :type "FUNC"}
 {:column 13 :line 9 :token "player" :type "FUNC"}
 {:column 20 :line 9 :token ":super-" :type "FUNC"}
 {:column 28 :line 9 :token "1" :type "NUMBER"}
 {:column 29 :line 9 :token "strength" :type "FUNC"}
 {:column 37 :line 9 :token ")" :type "RPAREN"}
 {:column 2 :line 10 :token "(" :type "LPAREN"}
 {:column 3 :line 10 :token "give-tool" :type "FUNC"}
 {:column 13 :line 10 :token "player" :type "FUNC"}
 {:column 20 :line 10 :token ":potion" :type "FUNC"}
 {:column 27 :line 10 :token ")" :type "RPAREN"}
 {:column 28 :line 10 :token ")" :type "RPAREN"}
 {:column 0 :line 12 :token "(" :type "LPAREN"}
 {:column 1 :line 12 :token "fn" :type "KEYWORD"}
 {:column 4 :line 12 :token "talk" :type "FUNC"}
 {:column 9 :line 12 :token "[" :type "LBRACKET"}
 {:column 10 :line 12 :token "other" :type "ARG"}
 {:column 15 :line 12 :token "]" :type "RBRACKET"}
 {:column 2
  :line 13
  :token "\"Talking can be dangerous...\""
  :type "DOCSTRING"}
 {:column 2 :line 14 :token "(" :type "LPAREN"}
 {:column 3 :line 14 :token "let" :type "KEYWORD"}
 {:column 7 :line 14 :token "[" :type "LBRACKET"}
 {:column 8 :line 14 :token "odds" :type "VARIABLE"}
 {:column 13 :line 14 :token "(" :type "LPAREN"}
 {:column 14 :line 14 :token "roll-dice" :type "FUNC"}
 {:column 23 :line 14 :token ")" :type "RPAREN"}
 {:column 24 :line 14 :token "]" :type "RBRACKET"}
 {:column 4 :line 15 :token "(" :type "LPAREN"}
 {:column 5 :line 15 :token "match" :type "KEYWORD"}
 {:column 11 :line 15 :token "odds" :type "FUNC"}
 {:column 6 :line 16 :token "(" :type "LPAREN"}
 {:column 7 :line 16 :token ">" :type "KEYWORD"}
 {:column 10 :line 16 :token "50" :type "NUMBER"}
 {:column 13 :line 16 :token "(" :type "LPAREN"}
 {:column 14 :line 16 :token "say" :type "FUNC"}
 {:column 18 :line 16 :token "other" :type "FUNC"}
 {:column 24 :line 16 :token "\"Hello!\"" :type "STRING"}
 {:column 32 :line 16 :token ")" :type "RPAREN"}
 {:column 6 :line 17 :token "_" :type "WILDCARD"}
 {:column 8 :line 17 :token "(" :type "LPAREN"}
 {:column 9 :line 17 :token "say" :type "FUNC"}
 {:column 13 :line 17 :token "other" :type "FUNC"}
 {:column 19 :line 17 :token "\"Bye!\"" :type "STRING"}
 {:column 25 :line 17 :token ")" :type "RPAREN"}
 {:column 26 :line 17 :token ")" :type "RPAREN"}
 {:column 27 :line 17 :token ")" :type "RPAREN"}
 {:column 28 :line 17 :token ")" :type "RPAREN"}
 {:column 0 :line 19 :token "{: setup : talk}" :type "TABLE"}])

(with-open [f (assert (io.open :tests/fixtures/lexer-test.fnl :r))]
  (let [contents (f:read :*all)
        lexer ((require :lexer) contents)
        {: view} (require :fennel)]
    (print (= (view (lexer)) (view expected-lexer-output)))))

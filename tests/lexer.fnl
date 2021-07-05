(local lexer (require :src.lexer))

(local expected-lexer-output [{:column 0 :line 1 :token "(" :type "LPAREN"}
 {:column 2 :line 1 :token "local" :type "SPECIAL"}
 {:column 8 :line 1 :token "core" :type "IDENTIFIER"}
 {:column 12 :line 1 :token "(" :type "LPAREN"}
 {:column 14 :line 1 :token "require" :type "IDENTIFIER"}
 {:column 22 :line 1 :token ":core" :type "STRING"}
 {:column 26 :line 1 :token ")" :type "RPAREN"}
 {:column 27 :line 1 :token ")" :type "RPAREN"}
 {:column 0 :line 3 :token "(" :type "LPAREN"}
 {:column 2 :line 3 :token "local" :type "SPECIAL"}
 {:column 8 :line 3 :token "tbl" :type "IDENTIFIER"}
 {:column 11 :line 3 :token "[" :type "LBRACKET"}
 {:column 13 :line 3 :token "1" :type "NUMBER"}
 {:column 15 :line 3 :token "2" :type "NUMBER"}
 {:column 17 :line 3 :token "3" :type "NUMBER"}
 {:column 19 :line 3 :token ":hello" :type "STRING"}
 {:column 26 :line 3 :token ":new-item_3" :type "STRING"}
 {:column 38 :line 3 :token ":my_super-3-computer" :type "STRING"}
 {:column 57 :line 3 :token "]" :type "RBRACKET"}
 {:column 58 :line 3 :token ")" :type "RPAREN"}
 {:column 0 :line 5 :token "(" :type "LPAREN"}
 {:column 2 :line 5 :token "fn" :type "SPECIAL"}
 {:column 5 :line 5 :token "setup" :type "IDENTIFIER"}
 {:column 10 :line 5 :token "[" :type "LBRACKET"}
 {:column 12 :line 5 :token "player" :type "IDENTIFIER"}
 {:column 17 :line 5 :token "]" :type "RBRACKET"}
 {:column 4 :line 6 :token "Setup the player with some basics" :type "STRING"}
 {:column 2 :line 7 :token "(" :type "LPAREN"}
 {:column 4 :line 7 :token "give-tool" :type "IDENTIFIER"}
 {:column 14 :line 7 :token "player" :type "IDENTIFIER"}
 {:column 21 :line 7 :token ":torch" :type "STRING"}
 {:column 26 :line 7 :token ")" :type "RPAREN"}
 {:column 2 :line 8 :token "(" :type "LPAREN"}
 {:column 4 :line 8 :token "give-tool" :type "IDENTIFIER"}
 {:column 14 :line 8 :token "player" :type "IDENTIFIER"}
 {:column 21 :line 8 :token ":map" :type "STRING"}
 {:column 24 :line 8 :token ")" :type "RPAREN"}
 {:column 2 :line 9 :token "(" :type "LPAREN"}
 {:column 4 :line 9 :token "give-tool" :type "IDENTIFIER"}
 {:column 14 :line 9 :token "player" :type "IDENTIFIER"}
 {:column 21 :line 9 :token ":potion" :type "STRING"}
 {:column 27 :line 9 :token ")" :type "RPAREN"}
 {:column 28 :line 9 :token ")" :type "RPAREN"}
 {:column 0 :line 11 :token "(" :type "LPAREN"}
 {:column 2 :line 11 :token "fn" :type "SPECIAL"}
 {:column 5 :line 11 :token "talk" :type "IDENTIFIER"}
 {:column 9 :line 11 :token "[" :type "LBRACKET"}
 {:column 11 :line 11 :token "other" :type "IDENTIFIER"}
 {:column 15 :line 11 :token "]" :type "RBRACKET"}
 {:column 4 :line 12 :token "Talking can be dangerous..." :type "STRING"}
 {:column 2 :line 13 :token "(" :type "LPAREN"}
 {:column 4 :line 13 :token "let" :type "SPECIAL"}
 {:column 7 :line 13 :token "[" :type "LBRACKET"}
 {:column 9 :line 13 :token "odds" :type "IDENTIFIER"}
 {:column 13 :line 13 :token "(" :type "LPAREN"}
 {:column 15 :line 13 :token "roll-dice" :type "IDENTIFIER"}
 {:column 23 :line 13 :token ")" :type "RPAREN"}
 {:column 9 :line 14 :token "chance" :type "IDENTIFIER"}
 {:column 16 :line 14 :token "50" :type "NUMBER"}
 {:column 4 :line 15 :token "(" :type "LPAREN"}
 {:column 6 :line 15 :token "if" :type "SPECIAL"}
 {:column 8 :line 15 :token "(" :type "LPAREN"}
 {:column 10 :line 15 :token ">" :type "SPECIAL"}
 {:column 12 :line 15 :token "odds" :type "IDENTIFIER"}
 {:column 17 :line 15 :token "chance" :type "IDENTIFIER"}
 {:column 22 :line 15 :token ")" :type "RPAREN"}
 {:column 8 :line 16 :token "(" :type "LPAREN"}
 {:column 10 :line 16 :token "say" :type "IDENTIFIER"}
 {:column 14 :line 16 :token "other" :type "IDENTIFIER"}
 {:column 21 :line 16 :token "Hello!" :type "STRING"}
 {:column 27 :line 16 :token ")" :type "RPAREN"}
 {:column 8 :line 17 :token "(" :type "LPAREN"}
 {:column 10 :line 17 :token "say" :type "IDENTIFIER"}
 {:column 14 :line 17 :token "other" :type "IDENTIFIER"}
 {:column 21 :line 17 :token "Now it" :type "STRING"}
 {:column 28 :line 17 :token "s" :type "IDENTIFIER"}
 {:column 30 :line 17 :token "a" :type "IDENTIFIER"}
 {:column 32 :line 17 :token "fight!" :type "IDENTIFIER"}
 {:column 38 :line 17 :token ")" :type "RPAREN"}
 {:column 39 :line 17 :token ")" :type "RPAREN"}
 {:column 40 :line 17 :token ")" :type "RPAREN"}
 {:column 41 :line 17 :token ")" :type "RPAREN"}
 {:column 0 :line 19 :token "{: setup : talk}" :type "KVPAIR_TABLE"}])

(with-open [f (assert (io.open :tests/fixtures/lexer-test.fnl :r))]
  (let [contents (f:read :*all)
        {: view} (require :fennel)
        {: begin} (require :lexer)]
    (print (= (view (begin contents 1 1 1 {})) (view expected-lexer-output)))))

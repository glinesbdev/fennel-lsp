(local keywords (require :keywords))

(local types {:arg :ARG
              :doc :DOCSTRING
              :fn :FUNC
              :keyword :KEYWORD
              :let :VARIABLE
              :lbracket :LBRACKET
              :lcurly :LCURLY
              :lparen :LPAREN
              :num :NUMBER
              :rbracket :RBRACKET
              :rcurly :RCURLY
              :rparen :RPAREN
              :str :STRING
              :sym :SYMBOL
              :tbl :TABLE
              :var :VARIABLE
              :wild :WILDCARD})

(local bindables {:collect true
                  :each true
                  :for true
                  :icollect true
                  :lambda true
                  "λ" true
                  :let true
                  :local true
                  :with-open true})

(local parsers {})

(fn paren? [char]
  (string.find char "[%(%)]"))

(fn bracket? [char]
  (string.find char "[%[%]]"))

(fn paren-or-bracket? [char]
  (or (paren? char) (bracket? char)))

(fn space? [char]
  (string.find char "%s"))

(fn number? [char]
  (string.find char "%d"))

(fn string? [char]
  (string.find char "[\"']"))

(fn table? [char]
  (string.find char "[%{]"))

(fn wildcard? [char]
  (string.find char "[_]"))

(fn symbol? [char]
  "Does a token not meet one of the above conditions?"
  (string.find char "[^%(%)%[%]\"'_%d%s%{%}]"))

(fn keyword? [token]
  (var found false)
  (each [_ list (pairs keywords) :until found]
    (each [_ keyword (ipairs list)]
      (when (= token keyword)
        (set found true))))
  found)

(fn bindable? [str]
  (. bindables str))

(fn parsers.create-token [tokens line col type token]
  (doto tokens
    (table.insert {: line :column (- col (length token)) : type : token})))

(fn parsers.tokenize-parens [text char pos col line tokens]
  (let [paren-type (match char
                     "(" types.lparen
                     ")" types.rparen
                     "{" types.lcurly
                     "}" types.rcurly
                     "[" types.lbracket
                     "]" types.rbracket)]
    (->> (parsers.create-token tokens char line col paren-type)
         (parsers.begin text (+ pos 1) (+ col 1) line))))

(fn parsers.tokenize-string [text pos col line tokens str-token]
  (match (string.sub text pos pos)
    (where str (string? str))
    (->> (parsers.create-token tokens str-token line col types.str)
         (parsers.begin text (+ pos 1) (+ col 1) line))
    char (parsers.tokenize-string text (+ pos 1) (+ col 1) line tokens
                                  (.. str-token char))))

(fn parsers.tokenize-number [text pos col line tokens str-token]
  (match (string.sub text pos pos)
    (where char (not (number? char)))
    (->> (parsers.create-token tokens str-token line col types.num)
         (parsers.begin text (+ pos 1) (+ col 1) line))
    num (parsers.tokenize-number text (+ pos 1) (+ col 1) line tokens
                                 (.. str-token num))))

(fn parsers.tokenize-table [text pos col line tokens str-token]
  (match (string.sub text pos pos)
    "}" (->> (parsers.create-token tokens (.. str-token "}") line col types.tbl)
             (parsers.begin text (+ pos 1) (+ col 1) line))
    tbl (parsers.tokenize-table text (+ pos 1) (+ col 1) line tokens
                                (.. str-token tbl))))

(fn parsers.tokenize-symbol [text pos col line tokens str-token]
  (match (string.sub text pos pos)
    (where sym (not (symbol? sym)))
    (->> (parsers.create-token tokens str-token line col types.sym)
         (parsers.begin text pos col line))
    char (parsers.tokenize-symbol text (+ pos 1) (+ col 1) line tokens
                                  (.. str-token char))))

(fn parsers.base [text pos col line tokens]
  (match (string.sub text pos pos)
    "" tokens
    "\n" (parsers.begin text (+ pos 1) 0 (+ line 1) tokens)
    (where spc (space? spc)) (parsers.begin text (+ pos 1) (+ col 1) line
                                            tokens)
    (where paren (paren-or-bracket? paren))
    (parsers.tokenize-parens text paren pos col line tokens)
    (where str (string? str))
    (parsers.tokenize-string text (+ pos 1) (+ col 1) line tokens "")
    (where num (number? num)) (parsers.tokenize-number text pos col line tokens
                                                       "")
    (where tbl (table? tbl)) (parsers.tokenize-table text pos col line tokens
                                                     "")
    (where sym (symbol? sym)) (parsers.tokenize-symbol text pos col line tokens
                                                       "")
    _ (parsers.begin text (+ pos 1) (+ col 1) line tokens)))

(fn parsers.begin [text pos col line tokens]
  (match (string.sub text pos pos)
    " " (parsers.begin text (+ pos 1) (+ col 1) line tokens)
    _ (parsers.base text pos col line tokens)))

{:begin parsers.begin}

(local keywords (require :keywords))

(local types {:arg :ARG
              :lbracket :LBRACKET
              :lcurly :LCURLY
              :lparen :LPAREN
              :macro :MACRO
              :num :NUMBER
              :rbracket :RBRACKET
              :rcurly :RCURLY
              :rparen :RPAREN
              :special :SPECIAL
              :str :STRING
              :ident :IDENTIFIER
              :kvpair :KVPAIR_TABLE
              :wild :WILDCARD})

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

(fn kvpair-table? [char]
  (string.find char "[%{]"))

(fn wildcard? [char]
  (string.find char "^[_]$"))

(fn identifier? [char]
  "Character that is not a paren, bracket, quote or space"
  (string.find char "[^%(%)%[%]\"\'%s%{%}]"))

(fn special? [token]
  (var found false)
  (each [_ special (ipairs keywords.specials) :until found]
    (when (= special token)
      (set found true)))
  found)

(fn macro? [token]
  (var found false)
  (each [_ mac (ipairs keywords.macros) :until found]
    (when (= token mac)
      (set found true)))
  found)

;; (fn parsers.create-token [tokens token line col type]
;;   (doto tokens
;;     (table.insert {: line :column (- col (length token)) : type : token})))

;; (fn parsers.tokenize-parens [text char pos col line tokens]
;;   (let [paren-type (match char
;;                      "(" types.lparen
;;                      ")" types.rparen
;;                      "{" types.lcurly
;;                      "}" types.rcurly
;;                      "[" types.lbracket
;;                      "]" types.rbracket)]
;;     (parsers.next text pos col 1 line tokens char paren-type)))

;; (fn parsers.tokenize-string [text pos col line tokens str-token]
;;   (match (string.sub text pos pos)
;;     (where str (string? str))
;;     (parsers.next text pos col 1 line tokens str-token types.str)
;;     char (parsers.tokenize-string text (+ pos 1) (+ col 1) line tokens
;;                                   (.. str-token char))))

;; (fn parsers.tokenize-number [text pos col line tokens str-token]
;;   (match (string.sub text pos pos)
;;     (where char (not (number? char)))
;;     (parsers.next text pos col 1 line tokens str-token types.num)
;;     num (parsers.tokenize-number text (+ pos 1) (+ col 1) line tokens
;;                                  (.. str-token num))))

;; (fn parsers.tokenize-kvpair [text pos col line tokens str-token]
;;   (match (string.sub text pos pos)
;;     "}" (parsers.next text pos col 1 line tokens (.. str-token "}")
;;                       types.kvpair)
;;     tbl (parsers.tokenize-kvpair text (+ pos 1) (+ col 1) line tokens
;;                                  (.. str-token tbl))))

;; ;; fnlfmt: skip
;; (fn parsers.tokenize-identifier [text pos col line tokens str-token]
;;   (match (string.sub text pos pos)
;;     (where ident (not (identifier? ident)))
;;     (if (macro? str-token)
;;         (parsers.next text pos col 1 line tokens str-token types.macro)
;;         (special? str-token)
;;         (parsers.next text pos col 1 line tokens str-token types.special)
;;         (wildcard? str-token)
;;         (parsers.next text pos col 1 line tokens str-token types.wild)
;;         (string.find str-token "^:[%w%d%-_]+$") ;; Match a "string" identifier i.e. :hello, :new-weapon-2, :new_item-3
;;         (parsers.next text pos col 0 line tokens str-token types.str)
;;         (paren-or-bracket? ident) ;; Special case where closing parens or bracket  were being skipped over
;;         (->> (parsers.create-token tokens str-token line col types.ident)
;;              (parsers.tokenize-parens text ident pos col line))
;;         (parsers.next text pos col 1 line tokens str-token types.ident))
;;     char
;;     (parsers.tokenize-identifier text (+ pos 1) (+ col 1) line tokens
;;                                  (.. str-token char))))

;; (fn parsers.next [text pos col next-count line tokens token token-type]
;;   (let [next-pos (+ pos next-count)
;;         next-col (+ col next-count)]
;;     (->> (parsers.create-token tokens token line col token-type)
;;          (parsers.begin text next-pos next-col line))))

;; (fn parsers.base [text pos col line tokens]
;;   (match (string.sub text pos pos)
;;     "" tokens
;;     "\n" (parsers.begin text (+ pos 1) 1 (+ line 1) tokens)
;;     (where spc (space? spc)) (parsers.begin text (+ pos 1) (+ col 1) line
;;                                             tokens)
;;     (where paren (paren-or-bracket? paren))
;;     (parsers.tokenize-parens text paren pos col line tokens)
;;     (where str (string? str))
;;     (parsers.tokenize-string text (+ pos 1) (+ col 1) line tokens "")
;;     (where num (number? num)) (parsers.tokenize-number text pos col line tokens
;;                                                        "")
;;     (where tbl (kvpair-table? tbl))
;;     (parsers.tokenize-kvpair text pos col line tokens "")
;;     (where ident (identifier? ident))
;;     (parsers.tokenize-identifier text pos col line tokens "")
;;     _ (parsers.begin text (+ pos 1) (+ col 1) line tokens)))

;; (fn parsers.begin [text pos col line tokens]
;;   (match (string.sub text pos pos)
;;     " " (parsers.begin text (+ pos 1) (+ col 1) line tokens)
;;     _ (parsers.base text pos col line tokens)))

;; {:begin parsers.begin}

(fn parsers.build-sexpr [str-rep col line sexprs]
  (doto sexprs
    (table.insert sexprs {:column (- col (length str-rep)) : line :sexpr str-rep})))

(fn parsers.gather-outer-sexpr [text pos col line str-rep sexprs]
  (match (string.sub text pos pos)
    "(" (parsers.gather-inner-sexpr text pos col line str-rep "" sexprs)))

(fn parsers.gather-inner-sexpr [text pos col line outer-str-rep inner-str-rep sexprs]
  )

(fn parsers.begin [text pos col line sexprs]
  (match (string.sub text pos pos)
    "" sexprs
    " " (begin text (+ pos 1) (+ col 1) line sexprs) ; skip any leading whitespace
    "\n" (begin text (+ pos 1) 1 (+ line 1) sexprs)
    "(" (gather-outer-sexp text pos col line "" sexprs)
    _ (begin text (+ pos 1) (+ col 1) line sexprs)))

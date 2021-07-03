(macro keywords []
   (let [keys #(doto (icollect [k (pairs $)] k) (table.sort))]
     {:macros (keys _SCOPE.parent.macros)
      :specials (keys _SCOPE.parent.specials)}))

(keywords)

(local core (require :core))

(local tbl [1 2 3 :hello])

(fn setup [player]
  "Setup the player with some basics"
  (give-tool player :torch)
  (give-tool player :map)
  (give-tool player :potion))

(fn talk [other]
  "Talking can be dangerous..."
  (let [odds (roll-dice)]
    (match odds
      (> 50) (say other "Hello!")
      _ (say other "Bye!"))))

{: setup : talk}

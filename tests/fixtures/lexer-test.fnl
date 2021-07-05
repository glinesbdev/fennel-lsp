(local core (require :core))

(local tbl [1 2 3 :hello :new-item_3 :my_super-3-computer])

(fn setup [player]
  "Setup the player with some basics"
  (give-tool player :torch)
  (give-tool player :map)
  (give-tool player :potion))

(fn talk [other]
  "Talking can be dangerous..."
  (let [odds (roll-dice)
        chance 50]
    (if (> odds chance)
        (say other "Hello!")
        (say other "Now it's a fight!"))))

{: setup : talk}

name "mongo"
description "MongoDB"
run_list "recipe[adam::base]",
  "recipe[mongodb::10gen_repo]",
  "recipe[mongodb::default]"

name "mongo"
description "MongoDB"
run_list "role[base]",
  "recipe[mongodb::10gen_repo]",
  "recipe[mongodb::default]"

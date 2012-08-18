name "dev"
description "Development Environment for Adam"
run_list "recipe[apt]",
  "recipe[motd-tail]",
  "recipe[git]",
  "recipe[rbenv]",
  "recipe[mongodb::10gen_repo]",
  "recipe[adam::apt-update]",
  "recipe[mongodb::default]",
  "recipe[adam]"

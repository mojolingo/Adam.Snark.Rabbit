name "dev"
description "Development Environment for Adam"
run_list "recipe[apt]",
  "recipe[motd-tail]",
  "recipe[git]",
  "recipe[rbenv]",
  "recipe[adam]"

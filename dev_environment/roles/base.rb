name "base"
description "Common components for all instances"
run_list "recipe[apt]",
  "recipe[motd-tail]",
  "recipe[adam::apt-update]"

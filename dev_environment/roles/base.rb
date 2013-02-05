name "base"
description "Common components for all instances"
run_list "recipe[apt]",
  "recipe[chef-solo-search]",
  "recipe[motd-tail]",
  "recipe[adam::apt-update]"

name "base"
description "Common components for all instances"
run_list "recipe[apt]",
  "recipe[adam::chef_deps]",
  "recipe[chef-solo-search]",
  "recipe[motd-tail]",
  "recipe[adam::apt-update]"

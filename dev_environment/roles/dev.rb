name "dev"
description "Development Environment for Adam"
run_list "recipe[apt]",
  "recipe[motd-tail]",
  "recipe[git]",
  "recipe[ssh_known_hosts]",
  "recipe[ruby_build]",
  "recipe[rbenv::user]",
  "recipe[mongodb::10gen_repo]",
  "recipe[adam::apt-update]",
  "recipe[mongodb::default]",
  "recipe[rabbitmq]",
  "recipe[rabbitmq::mgmt_console]",
  "recipe[ejabberd]",
  "recipe[adam]"

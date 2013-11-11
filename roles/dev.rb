name "dev"
description "Development Environment for Adam"
run_list "role[amqp]",
  "role[xmpp]",
  "role[mongo]",
  "role[freeswitch]",
  "recipe[adam::dev]",
  "role[app]"

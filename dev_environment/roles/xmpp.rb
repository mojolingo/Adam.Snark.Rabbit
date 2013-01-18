name "xmpp"
description "XMPP Server"
run_list "role[base]",
  "recipe[ejabberd]"

name "xmpp"
description "XMPP Server"
run_list "recipe[adam::base]",
  "recipe[adam::xmpp]"

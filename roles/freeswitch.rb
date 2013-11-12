name "freeswitch"
description "FreeSWITCH Rayo server"
run_list "recipe[adam::base]",
  "recipe[freeswitch::rayo]",
  "recipe[adam::rayo]"

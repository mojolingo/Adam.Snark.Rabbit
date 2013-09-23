name "amqp"
description "AMQP Broker"
run_list "role[base]",
  "recipe[rabbitmq]",
  "recipe[rabbitmq::mgmt_console]"

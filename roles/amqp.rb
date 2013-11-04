name "amqp"
description "AMQP Broker"
run_list "role[base]",
  "recipe[adam::rabbitmq]"

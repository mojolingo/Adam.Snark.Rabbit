name "amqp"
description "AMQP Broker"
run_list "recipe[adam::base]",
  "recipe[adam::rabbitmq]"

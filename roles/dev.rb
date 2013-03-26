name "dev"
description "Development Environment for Adam"
run_list "role[base]",
  "role[amqp]",
  "role[xmpp]",
  "role[mongo]",
  "role[voip-app]",
  "role[app]"

override_attributes :freeswitch => {
  :modules => {
    :rayo => {
      :listeners => {
        "$${domain}" => 5224
      }
    }
  }
}

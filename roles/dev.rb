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
      :listeners => [
        {
          :type => "c2s",
          :port => "5224",
          :address => "$${rayo_ip}",
          :acl => ""
        },
        {
          :type => "c2s",
          :port => "5224",
          :address => "127.0.0.1",
          :acl => ""
        }
      ]
    }
  }
}

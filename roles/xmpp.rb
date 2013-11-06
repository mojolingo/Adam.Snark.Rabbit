name "xmpp"
description "XMPP Server"
run_list "recipe[adam::base]",
  "recipe[adam::xmpp]"
default_attributes 'ejabberd' => {
  'auth_method' => 'external',
  'auth_attributes' => {
    'extauth_program' => "bash --login -c '/etc/ejabberd/ext_auth'"
  },
  'registration_allowed' => false
}

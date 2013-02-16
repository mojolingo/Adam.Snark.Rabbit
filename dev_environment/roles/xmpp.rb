name "xmpp"
description "XMPP Server"
run_list "role[base]",
  "recipe[ejabberd]"
default_attributes 'ejabberd' => {
  'auth_method' => 'external',
  'auth_attributes' => {
    'extauth_program' => "bash --login -c '/etc/ejabberd/ext_auth'"
  }
}

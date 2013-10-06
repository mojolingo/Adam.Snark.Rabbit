name "voip-app"
description "VoIP app server"
run_list "role[base]",
  "recipe[freeswitch]"
override_attributes :freeswitch => {
  :tls_only => false,
  :dialplan => {
    :head_fragments => '<extension name="adhearsion">
  <condition>
    <action application="rayo"/>
  </condition>
</extension>'
  }
}

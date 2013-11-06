name "freeswitch"
description "FreeSWITCH Rayo server"
run_list "recipe[adam::base]",
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

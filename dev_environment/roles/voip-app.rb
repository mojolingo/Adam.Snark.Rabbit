name "voip-app"
description "VoIP app server"
run_list "role[base]",
  "recipe[freeswitch]"
override_attributes :freeswitch => {
  :git_uri => 'git://github.com/grasshoppergroup/FreeSWITCH-rayo.git',
  :git_branch => 'master',
  :tls_only => false,
  :dialplan => {
    :head_fragments => '<extension name="adhearsion">
  <condition>
    <action application="rayo" data=""/>
  </condition>
</extension>'
  }
}

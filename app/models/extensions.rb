class Extension < ActiveLdap::Base
  ldap_mapping :dn_attribute => 'uid', :prefix => 'ou=Extensions', :classes => ['top', 'AsteriskUser', 'AsteriskVoiceMail']
end

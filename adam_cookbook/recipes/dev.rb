template "#{node['freeswitch']['confpath']}/autoload_configs/rayo.conf.xml" do
  owner node['freeswitch']['user']
  group node['freeswitch']['group']
  source 'rayo.conf.xml.erb'
  mode 0644
  variables listeners: [
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
  notifies :restart, "service[#{node['freeswitch']['service']}]"
end

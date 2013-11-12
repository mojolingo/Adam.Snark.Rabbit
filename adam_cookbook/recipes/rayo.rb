template "#{node['freeswitch']['confpath']}/autoload_configs/rayo.conf.xml" do
  owner node['freeswitch']['user']
  group node['freeswitch']['group']
  source 'rayo.conf.xml.erb'
  mode 0644
  variables listeners: node['adam']['rayo']['listeners']
  notifies :restart, "service[#{node['freeswitch']['service']}]"
end

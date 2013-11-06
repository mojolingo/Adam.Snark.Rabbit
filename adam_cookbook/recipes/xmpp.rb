include_recipe "ejabberd"

rbenv_gem 'faraday'
rbenv_gem 'faraday_middleware'

template '/etc/ejabberd/ext_auth' do
  source 'ejabberd_auth.erb'
  user 'ejabberd'
  group 'ejabberd'
  mode "770"
  variables :memory_base_url => node['adam']['memory_base_url'],
            :internal_password => node['adam']['internal_password']
  notifies :restart, resources(:service => "ejabberd"), :immediately
end
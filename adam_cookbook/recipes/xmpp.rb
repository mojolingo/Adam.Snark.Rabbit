chef_gem "chef-rewind"
require 'chef/rewind'

include_recipe "ejabberd"

rewind "template[/etc/ejabberd/ejabberd.cfg]" do
  source "ejabberd.cfg.erb"
  cookbook_name "adam"
end

node.default['rbenv']['group_users'] << 'ejabberd'

include_recipe 'rbenv'
include_recipe 'rbenv::ruby_build'

ruby = '2.0.0-p247'
rbenv_ruby ruby do
  global true
end

rbenv_gem 'faraday' do
  ruby_version ruby
end

rbenv_gem 'faraday_middleware' do
  ruby_version ruby
end

template '/etc/ejabberd/ext_auth' do
  source 'ejabberd_auth.erb'
  user 'ejabberd'
  group 'ejabberd'
  mode "770"
  variables :memory_base_url => node['adam']['memory_base_url'],
            :internal_username => node['adam']['memory']['internal_username'],
            :internal_password => node['adam']['memory']['internal_password']
  notifies :restart, resources(:service => "ejabberd")
end

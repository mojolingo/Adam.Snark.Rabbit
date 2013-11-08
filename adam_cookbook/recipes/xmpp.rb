chef_gem "chef-rewind"
require 'chef/rewind'

include_recipe "ejabberd"

rewind "template[/etc/ejabberd/ejabberd.cfg]" do
  source "ejabberd.cfg.erb"
  cookbook_name "adam"
end

include_recipe "ruby_build"
include_recipe "rbenv::system_install"

ruby_version = '2.0.0-p0'
rbenv_ruby ruby_version
rbenv_global ruby_version
rbenv_gem 'faraday'
rbenv_gem 'faraday_middleware'

template '/etc/ejabberd/ext_auth' do
  source 'ejabberd_auth.erb'
  user 'ejabberd'
  group 'ejabberd'
  mode "770"
  variables :memory_base_url => node['adam']['memory_base_url'],
            :internal_username => node['adam']['memory']['internal_username'],
            :internal_password => node['adam']['memory']['internal_password']
  notifies :restart, resources(:service => "ejabberd"), :immediately
end

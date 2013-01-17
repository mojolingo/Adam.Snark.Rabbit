rabbitmq_user "rails" do
  password "password"
  action :add
  notifies :restart, "service[rabbitmq-server]"
end

rabbitmq_user "rails" do
  vhost "/"
  permissions '".*" ".*" ".*"'
  action :set_permissions
end

rabbitmq_user "fingers" do
  password "password"
  action :add
  notifies :restart, "service[rabbitmq-server]"
end

rabbitmq_user "fingers" do
  vhost "/"
  permissions '".*" ".*" ".*"'
  action :set_permissions
end

rabbitmq_user "brain" do
  password "password"
  action :add
  notifies :restart, "service[rabbitmq-server]"
end

rabbitmq_user "brain" do
  vhost "/"
  permissions '".*" ".*" ".*"'
  action :set_permissions
end

rabbitmq_vhost "/test" do
  action :add
end

rabbitmq_user "guest" do
  password "pass"
  action :add
  notifies :restart, "service[rabbitmq-server]"
end

rabbitmq_user "guest" do
  vhost "/test"
  permissions '".*" ".*" ".*"'
  action :set_permissions
end

user "adam" do
  system true
  comment "Adam User"
  home "/home/adam"
  supports :manage_home => true
end

application "adam" do
  path "/srv/adam"
  owner "adam"
  group "adam"

  repository node['adam']['app_repo_url']
  revision node['adam']['app_repo_ref']

  deploy_key node['adam']['deploy_key']
end

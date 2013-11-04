include_recipe 'rabbitmq'
include_recipe 'rabbitmq::mgmt_console'
include_recipe 'adam::rabbitmq_users'

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

rabbitmq_user "ears" do
  password "password"
  action :add
  notifies :restart, "service[rabbitmq-server]"
end

rabbitmq_user "ears" do
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

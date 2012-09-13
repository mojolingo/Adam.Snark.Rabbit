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

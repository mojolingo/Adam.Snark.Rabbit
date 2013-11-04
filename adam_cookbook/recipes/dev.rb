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

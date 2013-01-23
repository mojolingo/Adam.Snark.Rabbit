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

if node[:adam][:standalone_deployment]
  application "adam" do
    path node['adam']['deployment_path']
    owner "adam"
    group "adam"

    repository node['adam']['app_repo_url']
    revision node['adam']['app_repo_ref']

    deploy_key node['adam']['deploy_key']

    nginx_load_balancer do
      application_port 3000
      application_server_role 'app'
    end

    before_restart do
      template File.join(node['adam']['deployment_path'], 'current', '.env') do
        source "env.erb"
      end

      template File.join(node['adam']['deployment_path'], 'current', '.foreman') do
        source "foreman.erb"
      end

      rbenv_script "app_dependencies" do
        code "rake setup"
        cwd File.join(node['adam']['deployment_path'], 'current')
      end

      rbenv_script "setup app services" do
        code "foreman export upstart /etc/init -a adam"
        cwd File.join(node['adam']['deployment_path'], 'current')
      end

      service 'adam' do
        action :enable
        provider Chef::Provider::Service::Upstart
      end
    end

    restart_command do
      service 'adam' do
        action :restart
        provider Chef::Provider::Service::Upstart
      end
    end
  end
else
  rbenv_script "app_dependencies" do
    code "rake setup"
    cwd File.join(node['adam']['deployment_path'], 'current')
  end

  rbenv_script "setup app services" do
    code "foreman export upstart /etc/init -a adam"
    cwd File.join(node['adam']['deployment_path'], 'current')
  end

  service 'adam' do
    action :enable
    provider Chef::Provider::Service::Upstart
  end
end

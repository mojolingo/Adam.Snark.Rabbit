include_recipe 'adam::rabbitmq_users'

user "adam" do
  system true
  comment "Adam User"
  home "/home/adam"
  supports :manage_home => true
end

sudo 'adam' do
  user      'adam'
  runas     'ALL'
  commands  ['/usr/sbin/service adam restart']
  nopasswd  true
end

%w{
  libqt4-dev
  qt4-qmake
}.each { |p| package p }

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
      set_host_header true
      static_files "/assets" => "memory/public/assets",
                   "/favicon.ico" => "memory/public/favicon.ico"
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

    restart_command "sudo service adam restart"
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

%w{
  libpcre3
  libpcre3-dev
}.each { |p| package p }

node.default['rbenv']['group_users'] << 'adam'

include_recipe "git"
include_recipe "postfix"
include_recipe 'rbenv'
include_recipe 'rbenv::ruby_build'

ruby_components = []

if node['adam']['memory']['install']
  ruby_components << 'memory'
end

if node['adam']['ears']['install']
  ruby_components << 'ears'
end

if node['adam']['fingers']['install']
  ruby_components << 'fingers'
end

if node['adam']['brain']['install']
  ruby_components << 'brain'
end

unless ruby_components.empty?
  ruby = '2.0.0-p0'

  rbenv_ruby ruby do
    global true
  end

  rbenv_gem 'bundler' do
    ruby_version ruby
  end

  rbenv_gem 'foreman' do
    ruby_version ruby
  end

  if node[:adam][:standalone_deployment]
    links = {}
    ruby_components.each do |component|
      links["#{component}/vendor/ruby"] = "#{component}/vendor/ruby"
    end

    links.each_pair do |source_dir, symlink|
      directory File.join(node['adam']['deployment_path'], 'shared', source_dir) do
        recursive true
        owner "adam"
        group "adam"
      end
    end

    %w{
      /etc/adam
      /var/log/adam
    }.each do |dir|
      directory dir do
        owner "adam"
      end
    end

    application "adam" do
      path node['adam']['deployment_path']
      owner "adam"
      group "adam"

      repository node['adam']['app_repo_url']
      revision node['adam']['app_repo_ref']

      deploy_key node['adam']['deploy_key']

      symlinks links

      nginx_load_balancer do
        application_port 3000
        application_server_role 'app'
        set_host_header true
        template 'nginx_site.erb'
        static_files "/assets" => "memory/public/assets",
                     "/favicon.ico" => "memory/public/favicon.ico"
      end

      before_deploy do
        template '/etc/adam/environment' do
          source "environment.erb"
          owner "adam"
          group "adam"
        end

        template "/etc/init/adam.conf" do
          source "upstart/adam.conf.erb"
          mode 0744
        end

        ruby_components.each do |component|
          template "/etc/init/adam-#{component}.conf" do
            source "upstart/component.conf.erb"
            mode 0744
            variables :component_name => component,
              :base_directory => File.join(node['adam']['deployment_path'], 'current')
          end
        end

        service 'adam' do
          action :enable
          provider Chef::Provider::Service::Upstart
        end
      end

      before_restart do
        ruby_components.each do |component|
          rbenv_execute "app_#{component}_dependencies" do
            command "bundle install --deployment --path vendor/ruby"
            cwd File.join(node['adam']['deployment_path'], 'current', component)
          end
        end

        # Just so that tests can run
        rbenv_execute "adam_common_dependencies" do
          command "bundle install --path vendor/ruby"
          cwd File.join(node['adam']['deployment_path'], 'current', 'adam_common')
          environment 'NOKOGIRI_USE_SYSTEM_LIBRARIES' => 'true'
        end
      end

      restart_command "sudo restart adam"
    end
  else
    ruby_components.each do |component|
      rbenv_execute "app_#{component}_dependencies" do
        command "bundle install --path vendor/ruby"
        cwd File.join(node['adam']['deployment_path'], 'current', component)
        environment 'NOKOGIRI_USE_SYSTEM_LIBRARIES' => 'true'
      end
    end

    rbenv_execute "setup app services" do
      command "foreman export upstart /etc/init -a adam"
      cwd File.join(node['adam']['deployment_path'], 'current')
    end

    service 'adam' do
      action :enable
      provider Chef::Provider::Service::Upstart
    end
  end
end

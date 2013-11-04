%w{
  libpcre3
  libpcre3-dev
}.each { |p| package p }

ruby_components = %w{
  memory
  ears
  fingers
  brain
}

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

      ruby_components.each do |component|
        rbenv_script "app_#{component}_dependencies" do
          code "bundle install --deployment --path vendor/ruby"
          cwd File.join(node['adam']['deployment_path'], 'current', component)
        end
      end

      # Just so that tests can run
      rbenv_script "adam_common_dependencies" do
        code "bundle install --path vendor/ruby"
        cwd File.join(node['adam']['deployment_path'], 'current', 'adam_common')
        environment 'NOKOGIRI_USE_SYSTEM_LIBRARIES' => 'true'
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
  ruby_components.each do |component|
    rbenv_script "app_#{component}_dependencies" do
      code "bundle install --path vendor/ruby"
      cwd File.join(node['adam']['deployment_path'], 'current', component)
      environment 'NOKOGIRI_USE_SYSTEM_LIBRARIES' => 'true'
    end
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

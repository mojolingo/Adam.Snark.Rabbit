$:.unshift File.expand_path('./lib', ENV['rvm_path'])
require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano/ext/multistage'

default_run_options[:pty] = true
default_environment['LC_CTYPE'] = 'en_US.UTF-8'
ssh_options[:forward_agent] = true

set :application,   "arabbit"
set :repository,    "git@github.com:mojolingo/Adam.Snark.Rabbit.git"
set :scm,           :git
set :deploy_via,    :export # :remote_cache
set :use_sudo,      false
set :keep_releases, 5
set :default_stage, "staging"

set :rvm_ruby_string, "ruby-1.9.3-p0"

namespace :deploy do
  desc "Restart app"
  task :restart, roles: :app do
    run "touch #{release_path}/tmp/restart.txt"
  end

  desc "Restart Adhearsion"
  task :restart_adhearsion, roles: :ahn do
    run "sudo -i god load #{release_path}/config/all.god"
    run "sudo -i god restart arabbit"
  end

  desc "Symlink shared resources on each release"
  task :symlink_shared do
    %w{config/environment.yml public/system tmp log}.each do |p|
      run "rm -rf #{release_path}/#{p} && ln -nfs #{shared_path}/#{p} #{release_path}/#{p}"
    end
  end
end

namespace :rvm do
  desc 'Trust rvmrc file'
  task :trust_rvmrc do
    run "rvm rvmrc trust #{latest_release}"
  end
end

after 'deploy:update_code', 'rvm:trust_rvmrc'
after 'deploy:update_code', 'deploy:symlink_shared'
after 'deploy:update_code' do
  run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
end
after 'deploy:update',      'deploy:cleanup'
after 'deploy:update',      'deploy:migrate'
after 'deploy:restart',     'deploy:restart_adhearsion'

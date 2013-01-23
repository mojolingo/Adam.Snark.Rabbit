#!/usr/bin/env rake

ruby_components = %w{
  adam_common
  memory
  ears
  fingers
  brain
}

task :setup do
  system "gem install bundler"
  ruby_components.each do |path|
    system "cd #{path} && bundle install"
  end
end

%w(spec).each do |task_name|
  desc "Run #{task_name} task for all projects"
  task task_name do
    errors = []
    ruby_components.each do |project|
      puts "Running rake #{task_name} for #{project}..."
      system(%(cd #{project} && #{$0} #{task_name})) || errors << project
    end
    fail "\n#{'*' * 30}\nErrors in #{errors.join(', ')}\n#{'*' * 30}" unless errors.empty?
  end
end

desc "Setup an app checkout and run all specs"
task :ci => :deployment_config do
  system 'gem install vagrant && gem install berkshelf && cd dev_environment && vagrant destroy -f && STANDALONE_DEPLOYMENT=true vagrant up && vagrant ssh -c "cd /srv/adam/current && sudo -u adam rake spec"'
  exit $?.exitstatus
end

desc "Create chef solo config for deployment environments"
task :deployment_config do
  system "rm -rf build && rm -rf tmp && mkdir build && mkdir tmp"
  system "cd dev_environment && berks install --path ../tmp/cookbooks"
  system "cd tmp && tar zcvf ../build/cookbooks.tgz cookbooks"
  system "cd dev_environment && tar zcvf ../build/roles.tgz roles"
end

task :default => :spec

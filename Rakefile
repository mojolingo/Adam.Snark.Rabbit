#!/usr/bin/env rake

ruby_components = %w{
  gateways/phone
  web
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
      system(%(cd #{project} && #{$0} #{task_name})) || errors << project
    end
    fail "\n#{'*' * 30}\nErrors in #{errors.join(', ')}\n#{'*' * 30}" unless errors.empty?
  end
end

task :default => :spec

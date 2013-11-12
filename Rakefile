#!/usr/bin/env rake

ruby_components = %w{
  memory
  ears
  fingers
  brain
}

%w(spec).each do |task_name|
  desc "Run #{task_name} task for all projects"
  task task_name do
    errors = []
    ruby_components.each do |project|
      puts "Running rake #{task_name} for #{project}..."
      system(%(cd #{project} && bundle exec #{$0} #{task_name})) || errors << project
    end
    fail "\n#{'*' * 30}\nErrors in #{errors.join(', ')}\n#{'*' * 30}" unless errors.empty?
  end
end

task :default => :spec

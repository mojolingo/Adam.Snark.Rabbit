# FIXME: Can we do better than duplicating this information in Cap and God?
@environments = {}
{
  :production => {:path => '/srv/apps/arabbit.mojolingo.com', :uid => 'arabbit', :gid => 'arabbit'},
  :staging => {:path => '/home/arabbit/application', :uid => 'arabbit', :gid => 'arabbit'}
}.map { |env, settings| @environments[env] = settings if File.exist? settings[:path] }

def ahn_command(action = :daemon, env = :production)
  "cd #{app_path(env)} && bundle exec ahn #{action} . --pid-file=#{pid_file(env)}"
end

def app_path(env)
  File.join @environments[env][:path], 'current'
end

def pid_file(env)
  File.join @environments[env][:path], 'shared', 'pids', 'adhearsion.pid'
end

def app_uid_gid(env)
  [@environments[env][:uid], @environments[env][:gid]]
end

def environment_file(env)
  File.join @environments[env][:path], 'shared', 'config', 'environment.yml'
end

def environment_variables(env)
  YAML.load_file environment_file(env)
end

# FIXME: Won't this result in having both environments "up" on every server that gets a deployment?
@environments.keys.each do |env|
  God.watch do |w|
    w.name  = "arabbit-adhearsion-#{env}"
    w.group = "arabbit"

    w.interval      = 30.seconds
    w.start_grace   = 20.seconds
    w.restart_grace = 20.seconds

    w.dir = @app_path

    w.start   = ahn_command :daemon, env
    w.stop    = ahn_command :stop, env
    w.restart = ahn_command :restart, env

    w.pid_file = pid_file env
    w.behavior :clean_pid_file

    w.uid, w.gid = app_uid_gid(env)

    w.env = environment_variables(env)

    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 5.seconds
        c.running = false
      end
    end

    w.restart_if do |restart|
      restart.condition(:memory_usage) do |c|
        c.above = 150.megabytes
        c.times = [3, 5] # 3 out of 5 intervals
      end

      restart.condition(:cpu_usage) do |c|
        c.above = 50.percent
        c.times = 5
      end
    end

    w.lifecycle do |on|
      on.condition(:flapping) do |c|
        c.to_state = [:start, :restart]
        c.times = 5
        c.within = 5.minute
        c.transition = :unmonitored
        c.retry_in = 10.minutes
        c.retry_times = 5
        c.retry_within = 2.hours
        c.notify = {:contacts => ['mojolingo'], :priority => 1, :category => 'adhearsion'}
      end
    end
  end
end

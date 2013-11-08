default[:adam][:environment] = "production"
default[:adam][:standalone_deployment] = true
default[:adam][:deployment_path] = "/srv/adam"
default[:adam][:app_repo_url] = "git@github.com:mojolingo/Adam.Snark.Rabbit.git"
default[:adam][:app_repo_ref] = "master"

default[:adam][:root_domain] = nil
default[:adam][:memory_base_url] = nil
default[:adam][:amqp_host] = 'localhost'
default[:adam][:rayo_domain] = node['adam']['root_domain']

default[:adam][:reporter][:url] = "http://errors.mojolingo.com"
default[:adam][:reporter][:api_key] = ""

default[:adam][:wit_api_key] = ""

override['rabbitmq']['version'] = "3.2.0"
override['rabbitmq']['package'] = "https://www.rabbitmq.com/releases/rabbitmq-server/v3.2.0/rabbitmq-server_3.2.0-1_all.deb"
override['rabbitmq']['virtualhosts'] = ['/test']
override['rabbitmq']['enabled_users'] = [
  { :name => "guest", :password => "guest", :rights =>
    [{:vhost => nil , :conf => ".*", :write => ".*", :read => ".*"}]
  },
  { :name => "rails", :password => "password", :rights =>
    [{:vhost => nil , :conf => ".*", :write => ".*", :read => ".*"}]
  },
  { :name => "fingers", :password => "password", :rights =>
    [{:vhost => nil , :conf => ".*", :write => ".*", :read => ".*"}]
  },
  { :name => "ears", :password => "password", :rights =>
    [{:vhost => nil , :conf => ".*", :write => ".*", :read => ".*"}]
  },
  { :name => "brain", :password => "password", :rights =>
    [{:vhost => nil , :conf => ".*", :write => ".*", :read => ".*"}]
  },
  { :name => "guest", :password => "pass", :rights =>
    [{:vhost => "/test" , :conf => ".*", :write => ".*", :read => ".*"}]
  }
]

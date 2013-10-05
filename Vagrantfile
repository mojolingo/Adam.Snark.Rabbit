Vagrant.configure("2") do |config|
  config.vm.box       = "precise64"
  config.vm.box_url   = "http://files.vagrantup.com/precise64.box"
  config.vm.hostname  = "local.adamrabbit.net"

  config.vm.provider :virtualbox do |vb|
    vb.name = "Adam-Snark-Rabbit-Dev"
  end

  config.vm.network :private_network, ip: "192.168.33.100"

  config.vm.synced_folder '.', "/srv/adam/current", nfs: true unless ENV['STANDALONE_DEPLOYMENT']

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.roles_path = "roles"
    chef.data_bags_path = "data_bags"

    chef.add_role "dev"

    chef.json = {
      jabber_domain: 'local.adamrabbit.net',
      'adam' => {
        'environment' => 'development',
        'root_domain' => 'local.adamrabbit.net',
        'standalone_deployment' => !!ENV['STANDALONE_DEPLOYMENT'],
        'deploy_key' => ENV['STANDALONE_DEPLOYMENT'] ? File.read('deploy_key') : nil,
        'internal_password' => 'fj8j4893jgg9jg9'
      }
    }

    chef.log_level = :debug
  end

  config.package.name = 'dev.adam.box'
end
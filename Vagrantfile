Vagrant.configure("2") do |config|
  config.vm.box = 'ubuntu/trusty64'

  config.vm.hostname  = "local.adamrabbit.net"

  config.vm.provider :virtualbox do |vb|
    vb.name = "Adam-Snark-Rabbit-Dev"
  end

  public_ip = "192.168.33.100"
  config.vm.network :private_network, ip: public_ip

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024]
  end

  config.vm.provision "docker"

  config.vm.provision "shell", inline: <<-FIG
  if [ ! -f /usr/local/bin/fig ]
  then
    echo -e "\n\ncd /vagrant" >> /home/vagrant/.bashrc
    echo "Installing Fig"
    curl --silent -L https://github.com/docker/fig/releases/download/0.5.2/linux > /usr/local/bin/fig
    chmod +x /usr/local/bin/fig
  fi
  cd /vagrant && fig build
  FIG
end

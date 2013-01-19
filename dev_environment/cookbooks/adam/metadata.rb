maintainer        "Mojo Lingo LLC"
maintainer_email  "adam@mojolingo.com"
license           "Proprietary"
description       "Installs Adam Snark Rabbit"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.0"
recipe            "adam", "Installs ruby, checks out adam"
recipe            "apt-update", "Updates apt repositories"

%w{ ubuntu debian }.each do |os|
  supports os
end

%w{
  ssh_known_hosts
  git
  rbenv
  application
}.each do |cb|
  depends cb
end

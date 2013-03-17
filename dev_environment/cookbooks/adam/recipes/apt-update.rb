execute 'echo "grub-pc grub-pc/install_devices multiselect /dev/sda" | debconf-set-selections'
execute "apt-get upgrade -y"

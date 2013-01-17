# Development Environment

1. Install `vagrant` and `berkshelf` gems
2. Place or symlink an SSH private key to be used to clone the app repo from Github in the VM in `dev_environment/deploy_key`. This will be copied to the VM. It can be a deploy key on the adam repo, or a Github user's SSH key.
3. `vagrant up` to download, launch, and provision the VMs

This is a simple Vagrant based development environment. All the usual vagrant rules apply.

Start the VM using `vagrant up`. You will need to provide an admin password to enable NFS share setup.

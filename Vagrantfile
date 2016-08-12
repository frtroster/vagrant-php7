# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

VAGRANTFILE_API_VERSION = "2"
settings = YAML.load_file 'parameters.yml'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    #Source: http://chef.github.io/bento/
    config.vm.box = "bento/ubuntu-16.04"
    config.vm.box_download_insecure = true

    config.vm.provision "shell", path: "manifests/puppet.sh"

    config.vm.provider "virtualbox" do |v|
        v.memory = 1024
        v.cpus = 2
    end

    # Always provision with puppet on up and reload
    config.vm.provision :puppet, run: "always" do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.module_path = "puppet/modules"
        puppet.options = "--verbose"
    end

    #configure hostnames
    config.vm.network "private_network", ip: "33.33.33.100"
    config.hostsupdater.aliases = settings['hostsupdater']['aliases']
    config.vm.synced_folder "projects", "/var/www", id: "application", :nfs => true
end

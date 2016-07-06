# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "msabramo/mssqlserver2014express"

  config.vm.provider "virtualbox" do |vb|
     vb.gui = false
     vb.customize ["modifyvm", :id, "--vrde", "on"]
   end
  config.vm.provision "shell", path:"init_database.cmd"
end

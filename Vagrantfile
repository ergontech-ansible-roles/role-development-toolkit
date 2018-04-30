# -*- mode: ruby -*-
# vi: set ft=ruby :

CPU = 1
RAM = 512
BOX = "ubuntu/xenial64"

DOMAIN  = ".ergon.com"
NETWORK = "10.1.0."

MACHINES = {
    "testserver"  => [NETWORK+"10", BOX, CPU, RAM]
}

Vagrant.configure("2") do |config|
  config.ssh.insert_key          = false
  config.hostmanager.enabled     = true
  config.hostmanager.manage_host = true

  MACHINES.each do | name, cfg |
    ipaddr, box, cpu, ram = cfg

    config.vm.define name do |machine|
      machine.vm.box              = box
      machine.vm.hostname         = name + DOMAIN

      machine.vm.provider "virtualbox" do |v|
        v.cpus   = cpu
        v.memory = ram
        v.name   = name
        v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ] # stop console logging
      end

      machine.vm.network "private_network", ip: ipaddr, netmask: "255.255.255.0"
    end
  end

end

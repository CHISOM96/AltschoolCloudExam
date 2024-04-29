Vagrant.configure("2") do |config|
  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/bionic64"
    master.vm.network "private_network", ip: "192.168.100.10"
    master.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
  end

  config.vm.define "slave" do |slave|
    slave.vm.box = "ubuntu/focal64"
    slave.vm.network "private_network", ip: "192.168.100.11"
    slave.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 1
    end
  end
end

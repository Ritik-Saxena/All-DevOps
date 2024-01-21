Vagrant.configure("2") do |config|

  # VM configurations for Ubuntu
  config.vm.define "web01" do |web01|
    web01.vm.box = "ubuntu/bionic64"
    web01.vm.network "private_network", ip: "192.168.56.41"
    web01.vm.hostname = "web01"

    config.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
    end

    config.vm.provision "shell", inline: <<-SHELL
      mkdir -p /var/log/barista_cafe_logs
  SHELL

  end

  # Configuration for CentOS 9 VM
  config.vm.define "web02" do |web02|
    web02.vm.box = "eurolinux-vagrant/centos-stream-9"
    web02.vm.network "private_network", ip: "192.168.56.42"
    web02.vm.hostname = "web02"

    config.vm.provision "shell", inline: <<-SHELL
      mkdir -p /var/log/barista_cafe_logs
      sudo chown vagrant:vagrant /var/log/barista_cafe_logs/
  SHELL
    
  end
end

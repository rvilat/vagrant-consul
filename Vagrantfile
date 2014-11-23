VAGRANTFILE_API_VERSION = "2"

# Defaults for config options defined in CONFIG
num_instances = 5

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "parallels/ubuntu-14.04"

  (1..num_instances).each do |i|
    config.vm.define vm_name = "consul-%02d" % i do |config|
      config.vm.hostname = vm_name

      ip = "172.20.20.#{i+10}"
      config.vm.network :private_network, ip: ip

$script = <<SCRIPT
mkdir -p /etc/salt
echo "bind_addr: #{ip}" > /etc/salt/grains
echo "join_addr: 172.20.20.11" >> /etc/salt/grains
echo "num_servers: #{num_instances}" >> /etc/salt/grains
SCRIPT

      config.vm.provision "shell", inline: $script

      ## For masterless, mount your salt file root
      config.vm.synced_folder "salt/srv/salt", "/srv/salt/"
      config.vm.synced_folder "salt/srv/pillar/", "/srv/pillar/"
      config.vm.synced_folder "salt/srv/formulas/", "/srv/formulas/"
      config.vm.synced_folder "salt/srv/pkgs/", "/srv/pkgs/"

      config.vm.provision :salt do |salt|
        salt.minion_config = "salt/minion"
        salt.run_highstate = true
        salt.log_level = "info"
        salt.colorize = true
      end
    end
  end
end

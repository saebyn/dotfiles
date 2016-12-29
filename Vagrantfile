VAGRANT_COMMAND = ARGV[0]

Vagrant.configure("2") do |config|

  # Use a suitable NixOS base. VM built with nixbox are tested to work with
  # this plugin.
  config.vm.box = "nixos/nixos-16.09-x86_64"

  # set hostname
  config.vm.hostname = "nixy"

  # Setup networking
  config.vm.network "private_network", ip: "10.0.2.15"

  # Add the htop package
  config.vm.provision :nixos,
    run: 'always',
    path: "system/vagrant.nix"

  config.vm.synced_folder ".", "/home/john/dotfiles"

  $script = <<-SCRIPT
  chown john /home/john
  cp /home/vagrant/.ssh/authorized_keys /home/john/.ssh/
  chown john /home/john/.ssh/authorized_keys
  SCRIPT

  config.vm.provision "shell", inline: $script, privileged: true

  $script = <<-SCRIPT
  cd /home/john/dotfiles
  ./install || true
  SCRIPT

  config.vm.provision "shell", inline: $script, privileged: false

  if VAGRANT_COMMAND == "ssh"
      config.ssh.username = 'john'
  end

  config.vm.provider "virtualbox" do |v|
      #v.gui = true
      #v.customize ["modifyvm", :id, "--vram", "64"]
      v.memory = 1024
      v.cpus = 2
  end
end

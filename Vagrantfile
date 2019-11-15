# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"
  config.vm.boot_timeout = 36000

  config.vm.provision :ansible_local do |ansible|
    ansible.playbook = "vagrant-provision.yml"
  end

  config.vm.provider "virtualbox" do |v|

    for x in [1,2] do
      file_to_disk = "disk#{x}.vdi"
      unless File.exist?(file_to_disk)
        v.customize ['createhd', '--filename', file_to_disk, '--size', 5 * 1024]
      end
      v.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', x, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
    end

  end

end

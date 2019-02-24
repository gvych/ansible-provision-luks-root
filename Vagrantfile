# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/xenial64"
  config.vm.boot_timeout = 36000

  config.vm.provider "virtualbox" do |v|

    file_to_disk = 'disk2.vdi'
    unless File.exist?(file_to_disk)
      v.customize ['createhd', '--filename', file_to_disk, '--size', 5 * 1024]
    end
    v.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]

    file_to_disk = 'disk3.vdi'
    unless File.exist?(file_to_disk)
      v.customize ['createhd', '--filename', file_to_disk, '--size', 5 * 1024]
    end
    v.customize ['storageattach', :id, '--storagectl', 'SCSI', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]

  end

end

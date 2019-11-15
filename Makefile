all:  boot

test:
	vagrant up
	ansible-playbook -i hosts-vagrant provision-in-rescue-mode.yml --skip-tags purge-disks

provision:
	ansible-playbook --private-key ./ssh-rescure-key provision-in-rescue-mode.yml --skip-tags purge-disks

boot:
	ansible-playbook -l new open-luks-on-boot.yml

gitlab-config:
	ansible-playbook -l new ferm-whitelist.yaml


kubespray-green:
	docker run -v ~/.kubespray.yml:/root/.kubespray.yml -v `pwd`/kubespray-green:/root/.kubespray  --entrypoint bash -it --name kubespray-green kubespray

TODO-setup-inside-docker:
	apt-get update && apt-get install -y python-pip python-dev libssl-dev libffi-dev gcc git
	pip install --upgrade setuptools ansible-modules-hashivault kubespray -r https://raw.githubusercontent.com/kubernetes-incubator/kubespray/v2.10.4/requirements.txt
	
	declare -a IPS=( 10.10.1.3 10.10.1.14 10.10.1.25 10.10.1.36 )
	kubespray prepare --nodes $(for i in {01..04}; do echo kuber${i}.myproject[ansible_ssh_host=${IPS[$i-1]}];done)
	
	cp -a ~/.kubespray/inventory/sample/group_vars  ~/.kubespray/inventory/group_vars
	sed -i "s/kube_network_plugin:.*/kube_network_plugin: weave/" ~/.kubespray/inventory/group_vars/k8s-cluster/k8s-cluster.yml
	PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)
	sed -i "s/.*weave_password:.*/weave_password: ${PASSWORD}/" ~/.kubespray/inventory/group_vars/k8s-cluster/k8s-net-weave.yml
	
	
	kubespray deploy


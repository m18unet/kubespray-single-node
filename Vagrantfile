# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.1.0", "< 3.0.0"
require 'yaml'

# Import configuration from config.yml
cfg = YAML.load_file("config.yml")['vagrant']


Vagrant.configure("2") do |config|

  config.vm.box = cfg['vm_box']
  config.vm.provider "virtualbox"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.box_check_update = false
  config.ssh.insert_key = false

  config.vm.define "node1"
  config.vm.hostname = "node1"
  config.vm.network :private_network, ip: cfg['vm_ip_addr']
  config.vm.network "forwarded_port", guest: 6443, host: 6443

  config.vm.provider :virtualbox do |vb|
    vb.cpus = cfg['vm_cpus']
    vb.memory = cfg['vm_memory']
    vb.name = "kubespray-single-node_node1"
    vb.gui = false
    vb.linked_clone = true
    vb.check_guest_additions = false
  end

  config.vm.provision "init", type: "shell", privileged: true, run: "once", inline: <<-SHELL
    set -eu -o pipefail
    git clone https://github.com/kubernetes-sigs/kubespray.git "#{cfg['kubespray_dir']}" \
      --branch "v#{cfg['kubespray_version']}" \
      --depth=1 \
      --single-branch 2> /dev/null || (cd "#{cfg['kubespray_dir']}" && git pull)
    chown -R "#{cfg['vm_username']}:#{cfg['vm_username']}" "#{cfg['kubespray_dir']}"
  SHELL

  config.vm.provision "ansible_local" do |ansible|
    ansible.install            = true
    ansible.install_mode       = "pip_args_only"
    ansible.compatibility_mode = "2.0"
    ansible.pip_args           = "-r #{cfg['kubespray_dir']}/requirements.txt"

    ansible.provisioning_path  = cfg['kubespray_dir']
    ansible.config_file        = "ansible.cfg"
    ansible.inventory_path     = "inventory/local/hosts.ini"
    ansible.limit              = "node1"
    ansible.playbook           = "cluster.yml"
    ansible.extra_vars         = {"ip": cfg['vm_ip_addr']}.merge(YAML.load(File.read("config.yml")))['ansible']['extra_vars']
    # ansible.tags               = ['ingress-controller']
    ansible.become             = true
    ansible.become_user        = "root"

    ansible.verbose            = false
    ansible.tmp_path           = "/tmp/vagrant-ansible"
  end

  config.vm.provision "post", type: "shell", privileged: true, run: "once", inline: <<-SHELL
    set -eu -o pipefail

    KUBE_DIR="/home/#{cfg['vm_username']}/.kube"
    mkdir -p ${KUBE_DIR}
    chmod 755 ${KUBE_DIR}

    ln -s /etc/kubernetes/admin.conf ${KUBE_DIR}/config -f
    chown -R "#{cfg['vm_username']}:#{cfg['vm_username']}" ${KUBE_DIR}
    chmod 644 ${KUBE_DIR}/config

    echo -e "alias k=kubectl" > /etc/profile.d/kubectl.sh
    echo -e "complete -o default -F __start_kubectl k"  >> /etc/profile.d/kubectl.sh

    cp ${KUBE_DIR}/config /vagrant/kubeconfig
  SHELL
end

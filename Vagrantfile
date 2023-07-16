# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.1.0", "< 3.0.0"

require 'yaml'
require_relative 'vagrant/utilities.rb'

Vagrant.configure("2") do |config|
  config.vm.box = SUPPORTED_OS[VM_OS_NAME][:box]
  config.vm.box_version = SUPPORTED_OS[VM_OS_NAME][:version]

  config.vm.provider "virtualbox"
  config.vm.synced_folder ".", "/vagrant"
  config.vm.box_check_update = false
  config.ssh.insert_key = false

  config.vm.define "node1"
  config.vm.hostname = "node1"
  config.vm.network :private_network, ip: VM_IP_ADDR

  config.vm.provider :virtualbox do |vb|
    vb.cpus = VM_CPUS
    vb.memory = VM_MEMORY
    vb.name = "kubespray-single-node_node1"
    vb.gui = false
    vb.linked_clone = true
    vb.check_guest_additions = false
  end

  config.vm.provision "init", type: "shell", privileged: true, run: "once", inline: <<-SHELL
    set -eu -o pipefail
    git clone https://github.com/kubernetes-sigs/kubespray.git "#{KUBESPRAY_DIR}" \
      --branch "#{KUBESPRAY_VERSION}" \
      --depth=1 \
      --single-branch 2> /dev/null || (cd "#{KUBESPRAY_DIR}" && git pull)
    chown -R "#{VM_USERNAME}:#{VM_USERNAME}" "#{KUBESPRAY_DIR}"
  SHELL

  config.vm.provision "ansible_local" do |ansible|
    ansible.install            = true
    ansible.install_mode       = "pip_args_only"
    ansible.compatibility_mode = "2.0"
    ansible.pip_args           = "-r #{KUBESPRAY_DIR}/requirements.txt"

    ansible.provisioning_path  = KUBESPRAY_DIR
    ansible.config_file        = "ansible.cfg"
    ansible.inventory_path     = "inventory/local/hosts.ini"
    ansible.limit              = "node1"
    ansible.playbook           = "cluster.yml"
    ansible.extra_vars         = {"ip": VM_IP_ADDR}.merge(YAML.load(File.read("ansible/extra-vars.yml")))
    # ansible.tags               = ["ingress-controller"]
    ansible.become             = true
    ansible.become_user        = "root"

    ansible.verbose            = false
    ansible.tmp_path           = "/tmp/vagrant-ansible"
  end

  config.vm.provision "post", type: "shell", privileged: true, run: "once", inline: <<-SHELL
    set -eu -o pipefail

    KUBE_DIR="/home/#{VM_USERNAME}/.kube"
    mkdir -p $KUBE_DIR
    chmod 755 $KUBE_DIR

    ln -s /etc/kubernetes/admin.conf $KUBE_DIR/config -f
    chown -R "#{VM_USERNAME}:#{VM_USERNAME}" $KUBE_DIR
    chmod 644 $KUBE_DIR/config

    echo -e "alias k=kubectl" > /etc/profile.d/kubectl.sh
    echo -e "complete -o default -F __start_kubectl k"  >> /etc/profile.d/kubectl.sh
  SHELL
end

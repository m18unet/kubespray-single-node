# Vagrant k8s

*SIngle node kubernetes cluster on vagrant vm using kubespray.*

> Note: This repo is modified version of fork from [m18unet/kubespray-single-node](https://github.com/m18unet/kubespray-single-node).
>
> Note: official kubespray repo also has a [vagrant file](https://github.com/kubernetes-sigs/kubespray/blob/master/Vagrantfile) which should work.



[Kind](https://kind.sigs.k8s.io/docs/user/quick-start/) is my first choice for my dev k8s cluster. But sometime specific workloads just refuse to run in a docker inside docker environment, this is where I use this repo as my single node dev k8s cluster using kubespray.

> Note: `minikube --vm` didn't worked well for one of my workload, hence kubespray in a vm.



**Usage:**

* Edit `config.yaml`, if required.
* `vagrant up`




# kubespray Single Node

This repository aims to create a Kubernetes cluster running on a single node using [kubespray](https://github.com/kubernetes-sigs/kubespray).

kubespray is a tool that automates the deployment and configuration of Kubernetes clusters. By leveraging kubespray, this project simplifies the process of setting up a Kubernetes environment on a single node.

For more detailed information about kubespray, you can review the [official documentation](https://kubespray.io).

## Prerequisites

Before you begin, make sure you have the following prerequisites installed on your machine:

- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) _(I tested it with version `6.1.44 r156814`)_
- [Vagrant](https://developer.hashicorp.com/vagrant/downloads) _(I tested it with version `2.3.6`)_

## Getting Started

```bash
vagrant up
```

## Quick Details

1. Customize the VM by reviewing the [`vagrant/utilities.rb`](vagrant/utilities.rb) file for options like CPU, memory, and OS. 

1. To override the values you want in the `kubespray` project, review the [`ansible/extra-vars.yml`](ansible/extra-vars.yml) file.

## Contribution

[Pull requests](https://github.com/m18unet/kubespray-single-node/compare) are welcome! Feel free to contribute and improve the project by submitting your changes.

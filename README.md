### kvm-terraform

See accompanying blog post at https://ebcrowder.dev/kvm-terraform/

Terraform infrastructure for spinning up virtual machines on linux servers using:

- [KVM](https://www.linux-kvm.org/page/Main_Page) for Linux VMs.
- [Terraform](https://www.terraform.io/) for automating the creation of VMs, the related virtual network and other resources.
- [terraform-provider-libvirtd](https://github.com/dmacvicar/terraform-provider-libvirt) this plugin provides Terraform with the necessary functionality to create KVM infrastructure.
- [CentOS](https://www.centos.org/) will be used for each virtual machine.
- [Fedora Cloud images](https://alt.fedoraproject.org/cloud/) will now be used instead of Centos

- bridge0_setup.sh list of commands to create bridge interface
- kvm_setup.sh list of commands to configure kvm on host server

The Terraform infrastructure code assumes that the VMs will be networked via a DHCP bridge network.

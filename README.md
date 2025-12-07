### kvm-terraform

See accompanying blog post at https://ebcrowder.dev/kvm-terraform/
NOTE: this blog post no longer exists

Terraform infrastructure for spinning up virtual machines on linux servers using:

- [KVM](https://www.linux-kvm.org/page/Main_Page) for Linux VMs.
- [Terraform](https://www.terraform.io/) for automating the creation of VMs, the related virtual network and other resources.
- [terraform-provider-libvirtd](https://github.com/dmacvicar/terraform-provider-libvirt) this plugin provides Terraform with the necessary functionality to create KVM infrastructure.
- [CentOS](https://www.centos.org/) will be used for each virtual machine.
- [Fedora Cloud images](https://alt.fedoraproject.org/cloud/) will now be used instead of Centos

## Setup Instructions

1. **Generate SSH keys** (first time only):
   ```bash
   ./init_keys.sh
   ```
   This creates `id_rsa` and `id_rsa.pub` for VM access and Ansible automation. Keys are not committed to the repository.

2. **Configure bridge network**:
   ```bash
   ./bridge0_setup.sh
   ```

3. **Setup KVM** (if needed):
   ```bash
   ./kvm_setup.sh
   ```

4. **Create disk pools**:
   ```bash
   ./create_diskpools.sh
   ```

5. **Deploy VMs**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

6. **Cleanup** (when done):
   ```bash
   ./cleanup_tf.sh
   ```

## Files

- `init_keys.sh` - Generate SSH key pair for VM access
- `bridge0_setup.sh` - Commands to create bridge interface
- `kvm_setup.sh` - Commands to configure KVM on host server
- `create_diskpools.sh` - Create libvirt storage pools
- `cleanup_tf.sh` - Commands to cleanup Terraform resources
- `main.tf` - Terraform infrastructure definition
- `cloud_init.cfg` - Cloud-init configuration for VMs

The Terraform infrastructure code assumes that the VMs will be networked via a DHCP bridge network.

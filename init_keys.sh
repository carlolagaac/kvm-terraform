#!/bin/bash
# Generate SSH key pair for VM access and Ansible automation
# This key will be deployed to all VMs via cloud-init

if [ ! -f id_rsa ]; then
    ssh-keygen -t rsa -b 4096 -f id_rsa -N "" -C "kvm-terraform-ansible"
    echo "✓ Generated new SSH key pair for VMs"
    echo "  Private key: id_rsa"
    echo "  Public key: id_rsa.pub"
else
    echo "✓ SSH keys already exist, skipping generation"
fi

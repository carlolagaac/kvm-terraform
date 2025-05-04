# List all domains first to verify
sudo virsh list --all

# Shutdown the domains if they're running
sudo virsh shutdown k3s-0
sudo virsh shutdown k3s-1
sudo virsh shutdown k3s-2
sudo virsh shutdown k3s-3

# Wait a moment for shutdown, then undefine them
sudo virsh undefine k3s-0
sudo virsh undefine k3s-1
sudo virsh undefine k3s-2
sudo virsh undefine k3s-3

# If they're still running, you might need to use destroy (force shutdown)
sudo virsh destroy k3s-0
sudo virsh destroy k3s-1
sudo virsh destroy k3s-2
sudo virsh destroy k3s-3

sudo virsh net-destroy kvmnet
sudo virsh net-undefine kvmnet


rm -rf .terraform*
rm -rf terraform*

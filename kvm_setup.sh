#
# Notes: https://dev.to/haydercyber/k8s-the-hard-way-4nmc
# 
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sudo systemctl disable --now firewalld




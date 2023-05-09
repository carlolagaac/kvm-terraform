#!/usr/bin/bash
# Configure the bridge network device
# Assumption is that en01 is the network device
# Change device and IP addresses appropriately
#
sudo nmcli c del bridge0
sudo nmcli connection add ifname bridge0 type bridge con-name bridge0
sudo nmcli connection add type bridge-slave ifname eno1 master bridge0
sudo nmcli c mod bridge0 ipv4.addresses 192.168.10.200/24 
sudo nmcli c mod bridge0 ipv4.dns "192.168.10.253 192.168.10.1 8.8.8.8"
sudo nmcli c mod bridge0 ipv4.gateway 192.168.10.1
sudo nmcli c mod bridge0 ipv4.method manual
sudo nmcli c up bridge0

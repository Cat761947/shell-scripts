#!/bin/bash

if [ -z "$1" ]; then
    sudo echo "No value provided for network SSID"
fi

if [ -z "$2" ]; then
    sudo echo "No value provided for network Password"
fi

sudo echo "Sudo privileges gained, starting setup..."

sudo echo "Updating packages..."

#Update System
sudo apt update
sudo apt upgrade -y

sudo echo "Setting up system config..."

#Setup System Config
sudo tee /etc/systemd/logind.conf > /dev/null <<EOL
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it under the
#  terms of the GNU Lesser General Public License as published by the Free
#  Software Foundation; either version 2.1 of the License, or (at your option)
#  any later version.
#
# Entries in this file show the compile time defaults. Local configuration
# should be created by either modifying this file (or a copy of it placed in
# /etc/ if the original file is shipped in /usr/), or by creating "drop-ins" in
# the /etc/systemd/logind.conf.d/ directory. The latter is generally
# recommended. Defaults can be restored by simply deleting the main
# configuration file and all drop-ins located in /etc/.
#
# Use 'systemd-analyze cat-config systemd/logind.conf' to display the full config.
#
# See logind.conf(5) for details.

[Login]
#NAutoVTs=6
#ReserveVT=6
#KillUserProcesses=no
#KillOnlyUsers=
#KillExcludeUsers=root
#InhibitDelayMaxSec=5
#UserStopDelaySec=10
#HandlePowerKey=poweroff
#HandlePowerKeyLongPress=ignore
#HandleRebootKey=reboot
#HandleRebootKeyLongPress=poweroff
#HandleSuspendKey=suspend
#HandleSuspendKeyLongPress=hibernate
#HandleHibernateKey=hibernate
#HandleHibernateKeyLongPress=ignore
HandleLidSwitch=ignore
#HandleLidSwitchExternalPower=suspend
#HandleLidSwitchDocked=ignore
#PowerKeyIgnoreInhibited=no
#SuspendKeyIgnoreInhibited=no
#HibernateKeyIgnoreInhibited=no
#LidSwitchIgnoreInhibited=yes
#RebootKeyIgnoreInhibited=no
#HoldoffTimeoutSec=30s
#IdleAction=ignore
#IdleActionSec=30min
#RuntimeDirectorySize=10%
#RuntimeDirectoryInodesMax=
#RemoveIPC=yes
#InhibitorsMax=8192
#SessionsMax=8192
#StopIdleSessionSec=infinity
EOL

sudo echo "Setting up network config..."

#Setup Network Config

network_interface=$(ls -1 /sys/class/net | while read iface; do if [ -d "/sys/class/net/$iface/wireless" ]; then echo "$iface"; break; fi; done)

if [ -z "$network_interface" ]; then
  sudo echo "No wireless interface detected, skipping Network Config Setup..."
  sleep 3
else
  
  if [ -z "$3" ]; then
    ip_address=192.168.1.250
  else
    ip_address=$1
  fi

  sudo mv /etc/netplan/50-cloud-init.yaml /etc/netplan/00-netplan-config.yaml
  sudo tee /etc/netplan/00-netplan-config.yaml > /dev/null <<EOL
network:
  version: 2
  renderer: networkd
  wifis:
    $network_interface:
      dhcp4: no
      dhcp6: no
      addresses: [$ip_address/24]
      nameservers:
        addresses: [1.1.1.1, 1.0.0.1]
      access-points:
        "$1":
          password: "$2"
      routes:
        - to: default
          via: 192.168.1.1
EOL

fi


sudo echo "Installing Docker..."

# Install Docker
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker $USER

sudo echo "Installing Kubernetes..."

#Install Kubernetes
sudo echo "In 10 seconds the fstab file will be opened, please comment out any lines with the word swap and then save the file"
sleep 10
sudo nano /etc/fstab
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo echo "Rebooting..."

#Restart
sudo systemctl reboot

#!/bin/bash

sudo apt update -y 
sudo apt upgrade -y

echo "GNOME Settings..."
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'area'
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

# Other apps on FlatHub
echo "Flatpak..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub -y \
com.discordapp.Discord \
com.axosoft.GitKraken \
com.mattjakeman.ExtensionManager \
md.obsidian.Obsidian \
com.slack.Slack \
com.spotify.Client \
com.visualstudio.code \
com.brave.Browser

#Setup DNS

echo "[Resolve]
DNS=193.110.81.0#dns0.eu
DNS=2a0f:fc80::#dns0.eu
DNS=185.253.5.0#dns0.eu
DNS=2a0f:fc81::#dns0.eu
DNSOverTLS=yes" | sudo tee -a /etc/systemd/resolved.conf

sudo systemctl restart systemd-resolved

# Setup Wayland
sudo mkdir -p /etc/systemd/system/gdm.service.d
sudo ln -sf /dev/null /etc/systemd/system/gdm.service.d/disable-wayland.conf
sudo rm -f /run/gdm3/custom.conf
sudo systemctl daemon-reload
sudo systemctl restart gdm
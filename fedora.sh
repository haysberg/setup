#!/bin/bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

echo "Ajout de VS Code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

sudo dnf check-update
sudo dnf remove -y *libreoffice* gnome-weather gnome-maps gnome-boxes *cheese* simple-scan rhythmbox
sudo dnf autoremove -y
sudo dnf update -y
sudo dnf install -y git code dnf-plugins-core gnome-tweaks
sudo dnf group install "Security Lab"

flatpak update -y

echo "GNOME Settings..."
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'area'
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

echo "Flatpak..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install -y \
com.discordapp.Discord \
com.axosoft.GitKraken \
com.mattjakeman.ExtensionManager \
org.mozilla.firefox/x86_64/stable \
com.slack.Slack \
com.spotify.Client 


hostnamectl set-hostname thiccpad

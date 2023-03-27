#!/bin/bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"



echo "Ajout de VS Code..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

sudo dnf check-update
sudo dnf remove -y *libreoffice* gnome-weather gnome-maps gnome-boxes *cheese* simple-scan rhythmbox
sudo dnf autoremove -y
sudo dnf update -y
sudo dnf install -y git code dnf-plugins-core gnome-tweaks dnf-plugins-core
sudo dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER

flatpak update -y

echo "GNOME Settings..."
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'area'
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

flatpak install -y \
com.discordapp.Discord \
com.mattjakeman.ExtensionManager \
com.slack.Slack \
com.spotify.Client \
io.github.shiftey.Desktop \
com.brave.Browser

hostnamectl set-hostname thiccpad

# Install Docker


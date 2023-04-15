#!/bin/bash

echo "Setup Jetbrains Mono..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 11'

flatpak install -y \
com.discordapp.Discord \
com.mattjakeman.ExtensionManager \
com.slack.Slack \
com.spotify.Client \
io.github.shiftey.Desktop \
org.mozilla.firefox

echo "Repo VSCode..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

echo "Installation des paquets..."
sudo dnf check-update
sudo dnf remove -y *libreoffice* gnome-weather gnome-maps gnome-boxes *cheese* simple-scan rhythmbox firefox
sudo dnf autoremove -y
sudo dnf update -y
sudo dnf install -y git code dnf-plugins-core gnome-tweaks dnf-plugins-core distrobox

flatpak update -y

echo "GNOME Settings..."
gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'area'
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
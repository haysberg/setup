#!/bin/bash

flatpak install flathub -y \
com.discordapp.Discord \
com.spotify.Client \
org.telegram.desktop \
org.signal.Signal \
com.github.tchx84.Flatseal \
io.github.mrvladus.List \
io.github.shiftey.Desktop \
dev.vencord.Vesktop \
rest.insomnia.Insomnia \
io.dbeaver.DBeaverCommunity \
org.mozilla.Thunderbird

echo "Repo VSCode..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

echo "Installation des paquets..."
sudo dnf check-update
sudo dnf remove -y *libreoffice* gnome-weather gnome-photos gnome-calendar gnome-maps gnome-boxes *cheese* simple-scan rhythmbox
sudo dnf autoremove -y
sudo dnf update -y

sudo dnf install -y git code dnf-plugins-core dnf-plugins-core fish helm distrobox kubernetes-client podman podman-compose

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 11'

sudo usermod -s /usr/bin/fish $USERNAME

echo "https://github.com/MuhammedKalkan/OpenLens/releases"
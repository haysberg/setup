#!/bin/bash

flatpak install flathub -y \
com.spotify.Client \
org.telegram.desktop \
org.signal.Signal \
io.github.milkshiift.GoofCord \
com.github.iwalton3.jellyfin-media-player

echo "Repo VSCode..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

echo "Installation des paquets..."
sudo dnf check-update
sudo dnf remove -y *libreoffice* gnome-weather gnome-photos gnome-calendar gnome-maps gnome-boxes *cheese* simple-scan rhythmbox
sudo dnf autoremove -y
sudo dnf update -y

sudo dnf install -y git code dnf-plugins-core dnf-plugins-core

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


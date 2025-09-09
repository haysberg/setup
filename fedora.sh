#!/bin/bash

flatpak remote-delete fedora
flatpak remote-delete fedora-testing
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub -y \
com.spotify.Client \
org.telegram.desktop \
org.signal.Signal \
com.github.iwalton3.jellyfin-media-player \
com.discordapp.Discord

echo "Repo VSCode..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null

echo "Installation des paquets..."
sudo dnf copr enable lilay/topgrade -y
sudo dnf check-update
sudo dnf remove -y *libreoffice* gnome-weather gnome-photos gnome-calendar gnome-maps gnome-boxes *cheese* simple-scan rhythmbox
sudo dnf autoremove -y
sudo dnf install -y git code topgrade dnf-plugins-core distrobox
sudo dnf update -y

curl -LsSf https://astral.sh/uv/install.sh | sh

distrobox create --name kali --image kalilinux/kali-rolling

topgrade -cy
#!/bin/bash

sudo hostnamectl set-hostname --static linucc

flatpak remote-delete fedora
flatpak remote-delete fedora-testing
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub -y \
com.spotify.Client \
org.telegram.desktop \
org.signal.Signal \
com.github.iwalton3.jellyfin-media-player \
com.discordapp.Discord \
dev.zed.Zed

echo "Installation des paquets..."
sudo dnf copr enable lilay/topgrade -y
sudo dnf check-update
sudo dnf remove -y *libreoffice* gnome-weather gnome-photos gnome-calendar gnome-maps gnome-boxes *cheese* simple-scan rhythmbox
sudo dnf autoremove -y
sudo dnf install -y git topgrade
topgrade -cy

curl -LsSf https://astral.sh/uv/install.sh | sh

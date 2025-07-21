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

echo "Repo VSCodium..."
sudo rpmkeys --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=download.vscodium.com\nbaseurl=https://download.vscodium.com/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/-/raw/master/pub.gpg\nmetadata_expire=1h\n" | sudo tee -a /etc/yum.repos.d/vscodium.repo

echo "Installation des paquets..."
sudo dnf check-update
sudo dnf remove -y *libreoffice* gnome-weather gnome-photos gnome-calendar gnome-maps gnome-boxes *cheese* simple-scan rhythmbox
sudo dnf autoremove -y
sudo dnf update -y

sudo dnf copr enable lilay/topgrade
sudo dnf install -y git codium topgrade dnf-plugins-core dnf-plugins-core clang distrobox

curl -sSL https://get.docker.com/ | sh
curl -LsSf https://astral.sh/uv/install.sh | sh
dockerd-rootless-setuptool.sh install
topgrade -cy
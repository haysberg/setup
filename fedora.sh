#!/bin/bash

flatpak remote-delete fedora
flatpak remote-delete fedora-testing
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub -y \
com.spotify.Client \
org.telegram.desktop \
org.signal.Signal \
com.github.iwalton3.jellyfin-media-player \
com.discordapp.Discord \
io.gitlab.librewolf-community

echo "Repo VSCode..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

echo "Installation des paquets..."
sudo dnf check-update
sudo dnf remove -y *libreoffice* gnome-weather gnome-photos gnome-calendar gnome-maps gnome-boxes *cheese* simple-scan rhythmbox
sudo dnf autoremove -y
sudo dnf update -y

sudo dnf install -y git code dnf-plugins-core dnf-plugins-core clang distrobox

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew tap hashicorp/tap
brew install hashicorp/tap/terraform topgrade awscli jq

curl -LsSf https://astral.sh/uv/install.sh | sh

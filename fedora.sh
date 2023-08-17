#!/bin/bash

gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'area'
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true

flatpak update -y

flatpak install -y \
com.discordapp.Discord \
com.mattjakeman.ExtensionManager \
com.spotify.Client \
com.axosoft.GitKraken \
com.brave.Browser \
md.obsidian.Obsidian \
org.mozilla.Thunderbird \
org.telegram.desktop \
org.signal.Signal \
flathub io.mpv.Mpv \
com.github.taiko2k.tauonmb

echo "Repo VSCode..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

echo "Installation des paquets..."
sudo dnf check-update
sudo dnf remove -y *libreoffice* gnome-weather gnome-photos gnome-calendar gnome-maps gnome-boxes *cheese* simple-scan rhythmbox firefox
sudo dnf autoremove -y
sudo dnf update -y
sudo dnf install -y git code dnf-plugins-core dnf-plugins-core git fish

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 12'

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
fish -c 'omf install bobthefish'

sudo usermod -s /usr/bin/fish $USERNAME

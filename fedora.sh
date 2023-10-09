#!/bin/bash

gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true
gsettings set org.gnome.desktop.peripherals.touchpad click-method 'area'
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true
gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'

flatpak install flathub -y \
com.discordapp.Discord \
com.spotify.Client \
com.axosoft.GitKraken \
md.obsidian.Obsidian \
org.telegram.desktop \
org.signal.Signal \
org.mozilla.firefox

echo "Repo VSCode..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

echo "Installation des paquets..."
sudo dnf check-update
sudo dnf remove -y *libreoffice* gnome-weather gnome-photos gnome-calendar gnome-maps gnome-boxes *cheese* simple-scan rhythmbox firefox
sudo dnf autoremove -y
sudo dnf update -y

sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

sudo dnf install -y git code dnf-plugins-core dnf-plugins-core fish helm distrobox kubectl

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 11'

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
fish -c 'omf install bobthefish'

sudo usermod -s /usr/bin/fish $USERNAME

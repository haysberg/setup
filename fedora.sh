#!/bin/bash

sudo hostnamectl set-hostname --static linucc
ujust update

flatpak install flathub -y \
com.spotify.Client \
org.telegram.desktop \
org.signal.Signal \
org.jellyfin.JellyfinDesktop \
dev.vencord.Vesktop \
dev.zed.Zed

curl -LsSf https://astral.sh/uv/install.sh | sh

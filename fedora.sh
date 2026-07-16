#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

flatpak install flathub -y \
com.spotify.Client \
org.telegram.desktop \
org.signal.Signal \
org.jellyfin.JellyfinDesktop \
com.discordapp.Discord \
dev.zed.Zed

curl -LsSf https://astral.sh/uv/install.sh | sh
brew install topgrade
curl -f https://zed.dev/install.sh | sh

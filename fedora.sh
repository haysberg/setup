#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

flatpak install flathub -y \
com.spotify.Client \
org.telegram.desktop \
org.signal.Signal \
org.jellyfin.JellyfinDesktop \
com.discordapp.Discord

# Remove preinstalled games; each uninstall is skipped silently if already gone
for app in org.kde.kmahjongg org.kde.kpat org.kde.kmines; do
  flatpak uninstall -y "$app" 2>/dev/null
done
flatpak uninstall -y --unused 2>/dev/null

curl -LsSf https://astral.sh/uv/install.sh | sh
brew install topgrade starship fzf fastfetch distrobox bat eza dust
curl -f https://zed.dev/install.sh | sh

### Shell configuration ###
# Fedora's default ~/.bashrc sources every file in ~/.bashrc.d/, so all shell
# config goes there as snippets instead of editing ~/.bashrc itself.
mkdir -p ~/.bashrc.d

cat > ~/.bashrc.d/10-brew.sh <<'EOF'
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
fi
EOF

cat > ~/.bashrc.d/20-history.sh <<'EOF'
shopt -s histappend
HISTSIZE=100000
HISTFILESIZE=200000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT='%F %T  '
EOF

cat > ~/.bashrc.d/30-fzf.sh <<'EOF'
# Ctrl-R fuzzy history search, Ctrl-T file picker, Alt-C cd
command -v fzf > /dev/null && eval "$(fzf --bash)"
EOF

cat > ~/.bashrc.d/40-starship.sh <<'EOF'
command -v starship > /dev/null && eval "$(starship init bash)"
EOF

cat > ~/.bashrc.d/50-aliases.sh <<'EOF'
if command -v eza &>/dev/null; then
    alias ls='eza'
    alias ll='eza -la --git'
    alias lt='eza --tree --level=2'
fi

if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
fi

if command -v dust &>/dev/null; then
    alias du='dust'
fi
EOF

# Starship theme: Hydro (plain Unicode, no Nerd Font needed). Upstream runs its
# dirty-repo check through zsh, which we don't have; patch it to plain sh.
curl -fsSL https://raw.githubusercontent.com/mattmc3/zephyr/main/plugins/prompt/themes/hydro.toml \
  | sed 's/^shell = \["zsh".*/shell = ["sh"]/' > ~/.config/starship.toml

### Git configuration ###
# GitHub username and noreply email, so commits link to the account without exposing it
git config --global user.name haysberg
git config --global user.email 29246792+haysberg@users.noreply.github.com

### KDE configuration ###

# Global dark theme (Fedora ships the light variant by default)
plasma-apply-lookandfeel -a org.fedoraproject.fedoradark.desktop

# CaskaydiaCove Nerd Font (Cascadia Code + icon glyphs), set as the fixed-width font
mkdir -p ~/.local/share/fonts
curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaCode.zip -o /tmp/caskaydia.zip
unzip -jo /tmp/caskaydia.zip '*.ttf' -d ~/.local/share/fonts
rm /tmp/caskaydia.zip
fc-cache -f
kwriteconfig6 --file kdeglobals --group General --key fixed "CaskaydiaCove Nerd Font Mono,10,-1,5,50,0,0,0,0,0"

# Konsole profile: same font, one point bigger than the system fixed-width font
mkdir -p ~/.local/share/konsole
cat > ~/.local/share/konsole/teo.profile <<'EOF'
[Appearance]
Font=CaskaydiaCove Nerd Font Mono,11,-1,5,50,0,0,0,0,0

[General]
Name=teo
Parent=FALLBACK/
EOF
kwriteconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile teo.profile

# Do not disturb: DND state is an "until" date, so use one far enough out to be permanent
kwriteconfig6 --file plasmanotifyrc --group DoNotDisturb --key Until "2099,1,1,0,0,0"
kwriteconfig6 --file plasmanotifyrc --group DoNotDisturb --key NotificationSoundsMuted true

# NumLock on at login (0 = on, 1 = off, 2 = leave unchanged)
kwriteconfig6 --file kcminputrc --group Keyboard --key NumLock 0

# No virtual keyboard: Fedora enables Plasma Keyboard by default, empty value = none
kwriteconfig6 --file kwinrc --group Wayland --key InputMethod ""

# No sticky screen edges: the cursor moves freely between monitors
kwriteconfig6 --file kwinrc --group EdgeBarrier --key EdgeBarrier 0
kwriteconfig6 --file kwinrc --group EdgeBarrier --key CornerBarrier false

# Night light on a fixed schedule, 10PM to 7AM
kwriteconfig6 --file kwinrc --group NightColor --key Active true
kwriteconfig6 --file kwinrc --group NightColor --key Mode Times
kwriteconfig6 --file kwinrc --group NightColor --key EveningBeginFixed 2200
kwriteconfig6 --file kwinrc --group NightColor --key MorningBeginFixed 0700
kwriteconfig6 --file kwinrc --group NightColor --key NightTemperature 2700

# No automatic screen locking, neither after idle time nor on wake from sleep
kwriteconfig6 --file kscreenlockerrc --group Daemon --key Autolock false
kwriteconfig6 --file kscreenlockerrc --group Daemon --key LockOnResume false

# When plugged in: performance profile, never dim, never turn off the screen, never suspend
kwriteconfig6 --file powerdevilrc --group AC --group Performance --key PowerProfile performance
kwriteconfig6 --file powerdevilrc --group AC --group Display --key DimDisplayWhenIdle false
kwriteconfig6 --file powerdevilrc --group AC --group Display --key DimDisplayIdleTimeoutSec -- -1
kwriteconfig6 --file powerdevilrc --group AC --group Display --key TurnOffDisplayWhenIdle false
kwriteconfig6 --file powerdevilrc --group AC --group Display --key TurnOffDisplayIdleTimeoutSec -- -1
kwriteconfig6 --file powerdevilrc --group AC --group SuspendAndShutdown --key AutoSuspendAction 0

# Panel: top edge, clock without date, pinned launchers, hidden tray icons.
# Uses the Plasma scripting API so it works whatever applet ids a fresh install assigns;
# requires a running Plasma session.
gdbus call --session --dest org.kde.plasmashell \
  --object-path /PlasmaShell --method org.kde.PlasmaShell.evaluateScript "$(cat <<'EOF'
const panel = panels()[0];
panel.location = "top";

const clock = panel.widgets("org.kde.plasma.digitalclock")[0];
if (clock) {
    clock.currentConfigGroup = ["Appearance"];
    clock.writeConfig("showDate", false);
    clock.writeConfig("autoFontAndSize", false);
    clock.writeConfig("fontFamily", "CaskaydiaCove Nerd Font Propo");
    clock.writeConfig("fontSize", 14);
    clock.writeConfig("boldText", true);
    clock.writeConfig("fontStyleName", "Bold");
    clock.writeConfig("fontWeight", 700);
}

const tasks = panel.widgets("org.kde.plasma.icontasks")[0];
if (tasks) {
    tasks.currentConfigGroup = ["General"];
    tasks.writeConfig("indicateAudioStreams", false);
    tasks.writeConfig("launchers", [
        "applications:org.kde.konsole.desktop",
        "preferred://filemanager",
        "preferred://browser",
        "file:///var/lib/flatpak/exports/share/applications/com.discordapp.Discord.desktop",
        "applications:dev.zed.Zed.desktop",
        "file:///var/lib/flatpak/exports/share/applications/com.spotify.Client.desktop",
        "file:///var/lib/flatpak/exports/share/applications/org.jellyfin.JellyfinDesktop.desktop",
        "file:///var/lib/flatpak/exports/share/applications/org.signal.Signal.desktop",
        "file:///var/lib/flatpak/exports/share/applications/org.telegram.desktop.desktop"
    ]);
}

const tray = panel.widgets("org.kde.plasma.systemtray")[0];
if (tray) {
    tray.currentConfigGroup = ["General"];
    tray.writeConfig("hiddenItems", [
        "org.kde.plasma.devicenotifier",
        "org.kde.plasma.addons.katesessions",
        "org.kde.plasma.brightness",
        "org.kde.plasma.notifications"
    ]);
}

if (panel.widgets("org.kde.plasma.systemmonitor.cpucore").length == 0) {
    panel.addWidget("org.kde.plasma.systemmonitor.cpucore");
}
if (panel.widgets("org.kde.plasma.mediacontroller").length == 0) {
    panel.addWidget("org.kde.plasma.mediacontroller");
}
// Media controls go right after the task icons (before the flexible separator),
// per-core CPU just left of the system tray. The widget "index" property is broken
// in Plasma 6.7, so write AppletOrder directly; this needs the plasmashell
// restart below to take effect.
const cpu = panel.widgets("org.kde.plasma.systemmonitor.cpucore")[0];
const media = panel.widgets("org.kde.plasma.mediacontroller")[0];
const sep = panel.widgets("org.kde.plasma.marginsseparator")[0];
if (cpu && media && tray) {
    const ids = panel.widgetIds.filter(id => id != cpu.id && id != media.id);
    ids.splice(ids.indexOf(sep ? sep.id : tray.id), 0, media.id);
    ids.splice(ids.indexOf(tray.id), 0, cpu.id);
    panel.currentConfigGroup = ["General"];
    panel.writeConfig("AppletOrder", ids.join(";"));
}
EOF
)" > /dev/null
systemctl --user restart plasma-plasmashell.service

# User avatar (GitHub profile picture), registered through AccountsService for SDDM & KDE
curl -fsSL https://avatars.githubusercontent.com/u/29246792 -o ~/.face.icon
busctl call org.freedesktop.Accounts "/org/freedesktop/Accounts/User$(id -u)" \
  org.freedesktop.Accounts.User SetIconFile s "$HOME/.face.icon"

# SDDM autologin into Plasma for this user
sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/autologin.conf > /dev/null <<EOF
[Autologin]
User=$USER
Session=plasma
EOF

# Plymouth splash on boot (graphical LUKS password prompt)
sudo rpm-ostree kargs --append-if-missing=rhgb --append-if-missing=quiet

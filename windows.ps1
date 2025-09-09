# To be used after activation / AtlasOS run

Start-Process "https://www.amd.com/en/support/download/drivers.html"

winget install -e --id RiotGames.LeagueOfLegends.EUW
winget install -e --id RiotGames.Valorant.EU
winget install -e --id File-New-Project.EarTrumpet
winget install -e --id Discord.Discord
winget install -e --id Spotify.Spotify
winget install -e --id Valve.Steam
winget install -e --id flux.flux
winget install -e --id OpenWhisperSystems.Signal
winget install -e --id Jellyfin.JellyfinMediaPlayer
winget install -e --id ProtonTechnologies.ProtonVPN

# Enable Do Not Disturb mode
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_TOASTS_ENABLED" -Value 0

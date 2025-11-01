# Enable Do Not Disturb mode
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_TOASTS_ENABLED" -Value 0

# To be used after AtlasOS
Start-Process "https://www.amd.com/en/support/download/drivers.html"
Start-Process "https://hyperx.com/pages/ngenuity"

Write-Output("Telechargement & Installation de 2XKO...")
$job1 = Start-Job {
    Invoke-WebRequest -Uri "https://lion.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.live.eu.exe" -OutFile "$HOME\Downloads\2xko.exe"
    Start-Process -Filepath "$HOME\Downloads\2xko.exe"
}

Write-Output("Installation des logiciels...")
winget install -e --id File-New-Project.EarTrumpet
winget install -e --id Discord.Discord
winget install -e --id Spotify.Spotify
winget install -e --id Valve.Steam
winget install -e --id flux.flux
winget install -e --id OpenWhisperSystems.Signal
winget install -e --id Jellyfin.JellyfinMediaPlayer
winget install -e --id Mozilla.Firefox.fr
winget install -e --id Telegram.TelegramDesktop

Wait-Job $job1

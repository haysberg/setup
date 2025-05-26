# List of package IDs to install
$packageIds = @(
    "Discord.Discord",
    "Spotify.Spotify",
    "Valve.Steam",
    "flux.flux",
    "Project.EarTrumpet",
    "OpenWhisperSystems.Signal",
    "LibreWolf.LibreWolf",
    "Jellyfin.JellyfinMediaPlayer"
)

# Loop through each package ID and start a job for each installation
foreach ($packageId in $packageIds) {
    Start-Job -ScriptBlock {
        param($id)
        winget install --id $id --accept-package-agreements --accept-source-agreements
    } -ArgumentList $packageId
}

Write-Output("Telechargement & Installation de LoL...")
$loljob = Start-Job {
    Invoke-WebRequest -Uri "https://lol.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.euw.exe" -OutFile "$HOME\Downloads\lol_install.exe"
    Start-Process -Filepath "$HOME\Downloads\lol_install.exe"
}

Get-Job | Wait-Job | Receive-Job

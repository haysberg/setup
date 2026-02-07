# To be used after AtlasOS
Start-Process "https://www.amd.com/en/support/download/drivers.html"

Write-Output("Telechargement & Installation de 2XKO...")
$job1 = Start-Job {
    Invoke-WebRequest -Uri "https://lion.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.live.eu.exe" -OutFile "$HOME\Downloads\2xko.exe"
    Start-Process -Filepath "$HOME\Downloads\2xko.exe"
}

Start-Process powershell -Verb RunAs -ArgumentList "-Command & {irm asheroto.com/winget | iex}" -Wait

$winget_packages = @(
    "File-New-Project.EarTrumpet",
    "Spotify.Spotify",
    "Valve.Steam",
    "flux.flux",
    "OpenWhisperSystems.Signal",
    "Jellyfin.JellyfinMediaPlayer",
    "Telegram.TelegramDesktop",
    "Proton.ProtonDrive",
    "Vencord.Vesktop",
    "Canva.Affinity",
    "topgrade-rs.topgrade",
    "ImputNet.Helium",
    "topgrade-rs.topgrade"
)

Start-Process powershell -Verb RunAs -ArgumentList "sudo config --enable normal"
Start-Process powershell -Verb RunAs -ArgumentList "-NoExit", "-Command", "Install-Module PSWindowsUpdate"

$jobs = @()
foreach ($package in $winget_packages) {
    $jobs += Start-Job -ScriptBlock {
        param($pkg)
        winget install -e --id $pkg --accept-source-agreements --accept-package-agreements
    } -ArgumentList $package
}

winget install 9NZKPSTSNW4P --source msstore

Write-Output "Waiting for winget installations to complete..."
Wait-Job -Job $jobs
Write-Output "All winget installations are complete."
Wait-Job $job1


topgrade -cy

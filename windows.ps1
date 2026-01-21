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
    "Microsoft.WindowsTerminal"
)

$jobs = @()
foreach ($package in $winget_packages) {
    $jobs += Start-Job -ScriptBlock {
        param($pkg)
        winget install -e --id $pkg --accept-source-agreements --accept-package-agreements
    } -ArgumentList $package
}

# Remove Xbox App
Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage

# Disable ms-gamingoverlay links
reg add HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR /f /t REG_DWORD /v "AppCaptureEnabled" /d 0
reg add HKEY_CURRENT_USER\System\GameConfigStore /f /t REG_DWORD /v "GameDVR_Enabled" /d 0

# Disable ms-gamebar links
reg add HKCR\ms-gamebar /f /ve /d URL:ms-gamebar 2>&1 >''
reg add HKCR\ms-gamebar /f /v "URL Protocol" /d "" 2>&1 >''
reg add HKCR\ms-gamebar /f /v "NoOpenWith" /d "" 2>&1 >''
reg add HKCR\ms-gamebar\shell\open\command /f /ve /d "\`"$env:SystemRoot\System32\systray.exe\`"" 2>&1 >''
reg add HKCR\ms-gamebarservices /f /ve /d URL:ms-gamebarservices 2>&1 >''
reg add HKCR\ms-gamebarservices /f /v "URL Protocol" /d "" 2>&1 >''
reg add HKCR\ms-gamebarservices /f /v "NoOpenWith" /d "" 2>&1 >''
reg add HKCR\ms-gamebarservices\shell\open\command /f /ve /d "\`"$env:SystemRoot\System32\systray.exe\`"" 2>&1 >''


Write-Output "Waiting for winget installations to complete..."
Wait-Job -Job $jobs
Write-Output "All winget installations are complete."
Wait-Job $job1

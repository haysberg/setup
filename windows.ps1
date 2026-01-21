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

# Remove the Game Bar for the current user
Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage

# Remove the Game Bar for all users on the PC
Get-AppxPackage -AllUsers Microsoft.XboxGamingOverlay | Remove-AppxPackage -AllUsers

# Prevent Windows from reinstalling it automatically
Get-ProvisionedAppxPackage -Online | Where-Object { $_.PackageName -match "XboxGamingOverlay" } | ForEach-Object { Remove-ProvisionedAppxPackage -Online -PackageName $_.PackageName }

# Disable Game DVR and App Capture
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Type DWord

# Redirects the ms-gamebar link to do nothing
reg add "HKEY_CLASSES_ROOT\ms-gamebar" /f /ve /d "URL:ms-gamebar"
# reg add "HKEY_CLASSES_ROOT\ms-gamebar" /f /v "NoOpenWith" /d ""
reg add "HKEY_CLASSES_ROOT\ms-gamebar\shell\open\command" /f /ve /d "$env:SystemRoot\System32\systray.exe"


Write-Output "Waiting for winget installations to complete..."
Wait-Job -Job $jobs
Write-Output "All winget installations are complete."
Wait-Job $job1

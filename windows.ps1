if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Write-Output("Installation de Chocolatey...")
# Run your code that needs to be elevated here...
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco feature enable -n=allowGlobalConfirmation
choco feature enable -n=useRememberedArgumentsForUpgrades

Write-Output("Telechargement & Installation de Valorant...")
$job1 = Start-Job {
    Invoke-WebRequest -Uri "https://valorant.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.live.eu.exe" -OutFile "$HOME\Downloads\valo_install_eu.exe"
    Start-Process -Filepath "$HOME\Downloads\valo_install_eu.exe"
}

Write-Output("Installation des programmes...")
choco install discord 7zip.install spotify steam vlc f.lux.install eartrumpet nvidia-display-driver --params "'/DCH'" greenshot amd-ryzen-chipset obs-studio

Wait-Job $job1

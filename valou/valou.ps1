if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Write-Output("Installation de Chocolatey...")
# Run your code that needs to be elevated here...
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco feature enable -n=allowGlobalConfirmation
choco feature enable -n=useRememberedArgumentsForUpgrades

Write-Output("Telechargement & Installation de Valorant...")
Invoke-WebRequest -Uri "https://valorant.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.live.eu.exe" -OutFile "$HOME\Downloads\valo_install_eu.exe"
Start-Process -Filepath "$HOME\Downloads\valo_install_eu.exe"

Write-Output("Installation de la langue fr-FR...")
Install-Language fr-FR

Write-Output("Installation des programmes...")
choco install waterfox discord spotify steam 7zip.install mpv eartrumpet nvidia-display-driver --params "'/DCH'" greenshot overwolf obs-studio

Write-Output("Dark Mode...")
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Value 0

# Set DNS to dns0.eu :
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses ("193.110.81.0","185.253.5.0")
Set-DNSClientServerAddress "Ethernet" -ServerAddresses (“2a0f:fc80::”,”2a0f:fc81::”)
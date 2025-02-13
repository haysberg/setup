if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Write-Output("Installation de Chocolatey...")
# Run your code that needs to be elevated here...
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco feature enable -n=allowGlobalConfirmation
choco feature enable -n=useRememberedArgumentsForUpgrades

Write-Output("Installation des programmes...")
$chocojob = Start-Job {
    choco install discord 7zip.install spotify steam telegram signal qbittorrent protondrive vscode protonvpn f.lux.install eartrumpet nvidia-display-driver --params "'/DCH'" greenshot amd-ryzen-chipset obs-studio
}

Write-Output("Telechargement & Installation de LoL...")
$job1 = Start-Job {
    Invoke-WebRequest -Uri "https://lol.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.euw.exe" -OutFile "$HOME\Downloads\lol_install.exe"
    Start-Process -Filepath "$HOME\Downloads\lol_install.exe"
}

Write-Output("Telechargement & Installation de NGENUITY...")
$job2 = Start-Job {
    Invoke-WebRequest -Uri "https://hyperx.gg/ngenuity-installer" -OutFile "$HOME\Downloads\ngenuity.exe"
    Start-Process -Filepath "$HOME\Downloads\ngenuity.exe"
}

irm https://get.activated.win | iex

Wait-Job $job1
Wait-Job $job2
Wait-Job $chocojob
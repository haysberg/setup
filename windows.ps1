Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

Write-Output("Telechargement & Installation de 2XKO...")
$job1 = Start-Job {
    Invoke-WebRequest -Uri "https://lion.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.live.eu.exe" -OutFile "$HOME\Downloads\2xko.exe"
    Start-Process -Filepath "$HOME\Downloads\2xko.exe"
    Invoke-WebRequest -Uri "https://downloads.affinity.studio/Affinity%20x64.exe" -OutFile "$HOME\Downloads\affinity.exe"
    Start-Process -Filepath "$HOME\Downloads\affinity.exe"
}

# To be used after AtlasOS
Start-Process "https://www.amd.com/en/support/download/drivers.html"

choco install f.lux tidal steam eartrumpet signal telegram protondrive dorion 
Wait-Job $job1

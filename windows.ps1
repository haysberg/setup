#Requires -Version 5.1
# To be used after AtlasOS
#
# Lancement : powershell -ExecutionPolicy Bypass -File .\windows.ps1
#   (ou une bonne fois pour toutes : Set-ExecutionPolicy RemoteSigned -Scope CurrentUser)

# NB : ne couvre QUE les cmdlets. Les commandes natives (scoop, topgrade) ne
# declenchent pas d'exception en PS 5.1 -> on teste $LASTEXITCODE a la main.
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'  # sinon Invoke-WebRequest est ~10x plus lent
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12  # PS 5.1 ne negocie pas TLS 1.2 par defaut sur les vieux builds

function Update-SessionPath {
    $env:Path = [Environment]::GetEnvironmentVariable('Path', 'User') + ';' + [Environment]::GetEnvironmentVariable('Path', 'Machine')
}

# Scoop installe en user-scope : il refuse de tourner en admin.
$identity = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
if ($identity.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "A lancer en utilisateur normal, pas en admin. Les etapes qui ont besoin de l'elevation la demandent elles-memes."
}

# Aucun gestionnaire de paquets ne couvre les drivers AMD
Start-Process "https://www.amd.com/en/support/download/drivers.html"

# 2XKO n'est package nulle part : on telecharge en arriere-plan pendant les installs
Write-Host "Telechargement de 2XKO en arriere-plan..."
$2xkoPath = "$HOME\Downloads\2xko.exe"
$job2xko = Start-Job {
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri "https://lion.secure.dyn.riotcdn.net/channels/public/x/installer/current/live.live.eu.exe" -OutFile $using:2xkoPath
}

# --- Scoop ---
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installation de Scoop..."
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
    Update-SessionPath
}

scoop install main/git  # requis pour ajouter des buckets

# Test-Path plutot que 'scoop bucket list' : le format de sortie a change selon les versions
$scoopRoot = if ($env:SCOOP) { $env:SCOOP } else { "$HOME\scoop" }
foreach ($bucket in @('extras', 'games')) {
    if (-not (Test-Path "$scoopRoot\buckets\$bucket")) { scoop bucket add $bucket }
}

# Noms qualifies par bucket : 'flux' existe dans main (FluxCD) ET extras (f.lux)
$scoopPackages = @(
    "main/topgrade"
    "extras/eartrumpet"
    "extras/spotify"
    "extras/flux"
    "extras/signal"
    "extras/telegram"
    "extras/jellyfin-media-player"
    "extras/proton-drive"
    "extras/discord"
    "extras/helium"
    "games/steam"
)
scoop install @scoopPackages
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Au moins un paquet scoop a echoue (code $LASTEXITCODE) - voir la sortie ci-dessus."
}

# --- Etapes qui exigent l'elevation ---
# Read-Host final : sans ca la fenetre elevee se ferme instantanement et on ne
# voit jamais si 'sudo config' ou Install-Module ont echoue.
Start-Process powershell -Verb RunAs -Wait -ArgumentList "-Command", 'sudo config --enable normal; Install-PackageProvider NuGet -Force | Out-Null; Install-Module PSWindowsUpdate -Force -Confirm:$false; Read-Host "Termine - Entree pour fermer"'

# --- 2XKO ---
Write-Host "Attente de la fin du telechargement de 2XKO..."
Receive-Job -Job $job2xko -Wait -AutoRemoveJob
if (Test-Path $2xkoPath) {
    Start-Process -FilePath $2xkoPath
} else {
    Write-Warning "Telechargement de 2XKO echoue, a faire a la main."
}

Update-SessionPath
topgrade -cy

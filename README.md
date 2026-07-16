## Windows
```
iwr -useb https://raw.githubusercontent.com/haysberg/setup/main/windows.ps1|iex
```

## Nvidia drivers (Windows)
```
choco install nvidia-display-driver --params "'/DCH'" -y
```

## Activation Windows
```
irm https://get.activated.win | iex
```

## Fedora
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/haysberg/setup/main/fedora.sh)"
```

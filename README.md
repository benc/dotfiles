# Install

## Macos/linux/wsl

    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply benc

## Windows 11

Prerequisites:

    winget install --id Microsoft.Powershell --source winget
    winget install --id Microsoft.WindowsTerminal

Prerequisites, run in an *elevated* powershell prompt:

    # gsudo
    winget install --exact gerardog.gsudo --interactive

    # git
    winget install --exact Git.Git --interactive

    # chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # age
    choco install age.portable

Run in a *regular* powershell prompt:

    (irm -useb https://get.chezmoi.io/ps1) | powershell -c -
    .\bin\chezmoi.exe init --apply benc

# Usage

## Most used commands:

    # edit dotfiles
    chezmoi edit

    # apply them on your system
    chezmoi apply

    # update system with the latest dotfiles
    chezmoi update

## Troubleshooting

    chezmoi -v apply
    chezmoi doctor

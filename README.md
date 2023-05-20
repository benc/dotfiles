# Install

## Macos/linux/wsl

If you're on a workstation, install 1Password and the CLI. Make sure they're coupled together.

    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply benc

## Windows 11

Prerequisites:

    winget install --id Microsoft.Powershell
    winget install --id Microsoft.WindowsTerminal

Prerequisites, run in an *elevated* powershell prompt:

    # gsudo
    winget install --exact gerardog.gsudo --interactive

    # git
    winget install --exact Git.Git --interactive

    # chocolatey
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # 1password CLI
    gsudo choco add op

Make sure 1Password exposes the SSH agent, and that the CLI is coupled.

Run in a *regular* powershell prompt:

    (irm -useb https://get.chezmoi.io/ps1) | powershell -c -
    .\bin\chezmoi.exe init https://github.com/benc/dotfiles.git
    chezmoi apply

# Usage

## Most used commands:

    # edit dotfiles
    chezmoi edit

    # apply them on your system
    chezmoi apply

    # update system with the latest dotfiles
    chezmoi update --init

## Troubleshooting

    chezmoi -v apply
    chezmoi doctor

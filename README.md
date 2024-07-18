# Install

## Macos/linux/wsl

If you're on a workstation, install 1Password and the CLI. Make sure they're coupled together.

    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply benc

## Windows 11

First, make sure you have [winget-cli](https://github.com/microsoft/winget-cli) installed.

Prerequisites:

    winget install --id Microsoft.VisualStudioCode
    winget install --id Microsoft.Powershell
    winget install --id Microsoft.WindowsTerminal
    Set-ExecutionPolicy RemoteSigned -scope CurrentUser
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')

Prerequisites, run in an *elevated* powershell prompt:

    # gsudo
    winget install --exact gerardog.gsudo --interactive

    # git
    winget install --exact Git.Git --interactive

Make sure 1Password exposes the SSH agent, and that the CLI is coupled.

Run in a *regular* powershell prompt:

    (irm -useb https://get.chezmoi.io/ps1) | powershell -c -
    .\bin\chezmoi.exe init https://github.com/benc/dotfiles.git
    .\bin\chezmoi.exe apply

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

Compedit issues:

    compaudit | xargs chmod g-w,o-w

### WSL2 backup

    wsl --terminate "Ubuntu-22.04"
    wsl --export Ubuntu-22.04 ubuntu-22.04-backup.tar
    wsl --import Ubuntu-22.04 <InstallationLocation> ubuntu-22.04-backup.tar

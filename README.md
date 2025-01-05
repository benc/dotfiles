# Install

DISCLAIMER: These are my dotfiles for bootstrapping a new system. They are tailored to my needs, and may not work for you. Use at your own risk.

For reference, my main machine is a Macbook Pro M3 max. I also have other little servers running macos and Linux. I have a Windows 11 homelab for AI research purposes, with a WSL setup there. I also use this repo for bootstrapping my own devcontainers.

The bulk is managed through chezmoi, with an interest in nix. I use 1Password for secrets management.

## Macos/linux

This script installs some tooling from the Mac App Store, so make sure you're logged in there.

Using curl:

    sh -c "$(curl -fsLS https://raw.githubusercontent.com/benc/dotfiles/main/scripts/bootstrap_dotfiles.sh)"

Using wget:

    sh -c "$(wget -qO- https://raw.githubusercontent.com/benc/dotfiles/main/scripts/bootstrap_dotfiles.sh)"

If you're using secrets, the script will install 1Password. It cannot do the whole setup, some manual action is needed. It will prompt you to navigate to the "developer" section. Make sure 1Password exposes the SSH agent, and that the CLI is coupled.

## Windows 11

Open Microsoft Store. Open the library, and make sure everything is up-to-date.

Install [UnigetUI](https://www.marticliment.com/unigetui/):

    winget install UniGetUI --source winget

Open UnigetUI and install all updates that are found.

Using UnigetUI, open the settings pane and install [scoop](https://scoop.sh).

Open a terminal and run the following commands:

    scoop bucket add versions
    scoop install main/7zip main/git main/pwsh main/scoop-search main/chezmoi main/1password-cli main/gsudo versions/vscode-insiders
    winget install AgileBits.1Password

Open 1Password, and log in. Open settings, and navigate to the "developer" section. Make sure 1Password exposes the SSH agent, and that the CLI is coupled. Verify:

    # this should list your 1password account
    op account list

    # verify that 1password can be used to log in:
    op signin

Get dotfiles repo:

    chezmoi init https://github.com/benc/dotfiles.git

Verify that everything is working:

    chezmoi doctor

Apply dotfiles, and profit:

    chezmoi apply --init

# Usage

## Most used commands:

    # edit dotfiles
    chezmoi edit

    # apply them on your system
    chezmoi apply

    # update system with the latest dotfiles
    chezmoi update --init

    # force run_once scripts
    chezmoi state delete-bucket --bucket=scriptState; chezmoi apply --init
    chezmoi state delete-bucket --bucket=scriptState; chezmoi update --init

## Troubleshooting

    chezmoi -v apply
    chezmoi doctor

### WSL2 backup

    wsl --terminate "Ubuntu-22.04"
    wsl --export Ubuntu-22.04 ubuntu-22.04-backup.tar
    wsl --import Ubuntu-22.04 <InstallationLocation> ubuntu-22.04-backup.tar

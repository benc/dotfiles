# Install

## Macos/linux/wsl

If you're on a workstation, install 1Password and the CLI. Make sure they're coupled together.

Using curl (macos):

    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply benc

Using wget (debian/ubuntu):

    sh -c "$(wget -qO - get.chezmoi.io)" -- init --apply benc

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

Compedit issues:

    compaudit | xargs chmod g-w,o-w

### WSL2 backup

    wsl --terminate "Ubuntu-22.04"
    wsl --export Ubuntu-22.04 ubuntu-22.04-backup.tar
    wsl --import Ubuntu-22.04 <InstallationLocation> ubuntu-22.04-backup.tar

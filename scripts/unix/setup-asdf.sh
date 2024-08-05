#!/bin/bash
rm -rf "${HOME}/.n"
rm -rf "${HOME}/.pyenv"
rm -rf "${HOME}/.rbenv"
rm -rf "${HOME}/.sdkman"

if [ ! -d $HOME/.asdf ]; then
    echo "💡 Installing asdf..."
    git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf
    . "$HOME/.asdf/asdf.sh"
    asdf update
fi

. "$HOME/.asdf/asdf.sh"

asdf plugin add nodejs
asdf plugin add ruby
asdf plugin add java
asdf plugin add maven
asdf plugin add gradle
asdf plugin add python
asdf plugin add golang
asdf plugin add rust

pushd "$HOME" || exit
asdf install
data=$(cat .tool-versions)
while read -r line; do
  if [[ -n "$line" ]]; then  # Check for empty lines
    tool=$(echo "$line" | cut -d ' ' -f 1)
    version=$(echo "$line" | cut -d ' ' -f 2-)
    echo "🔧 Configuring ${tool} to ${version}"
    asdf global "${tool}" "${version}"
  fi
done <<< "$data"

asdf reshim python
rm -rf "$HOME"/.local/bin/pip*

echo "🔧 Configuring Java versions..."
asdf install java latest:temurin-11
asdf install java latest:temurin-17
asdf install java latest:temurin-21

popd || exit

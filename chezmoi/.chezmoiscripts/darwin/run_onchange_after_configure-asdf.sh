#!/bin/bash
if [[ -n "${CHEZMOI_SOURCE_DIR}" ]]; then
    . ${CHEZMOI_SOURCE_DIR}/../scripts/source-tooling.sh
fi

if [ -d $HOME/.asdf ]; then
  echo "🔧 Configure ASDF..."

  . "$HOME/.asdf/asdf.sh"

  asdf plugin add nodejs
  asdf plugin add ruby
  asdf plugin add java
  asdf plugin add maven
  asdf plugin add gradle
  asdf plugin add python
  asdf plugin add golang
  asdf plugin add rust
  asdf plugin add sbt

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
fi

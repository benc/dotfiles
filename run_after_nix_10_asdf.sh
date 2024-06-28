#!/bin/bash

echo "🚀 Installing asdf and setting up .tool-versions globally..."
pushd "$HOME" || exit
. "$HOME/.asdf/asdf.sh"
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

echo "🔧 Configuring Java versions..."
asdf install java latest:temurin-11
asdf install java latest:temurin-17
asdf install java latest:temurin-21

popd || exit

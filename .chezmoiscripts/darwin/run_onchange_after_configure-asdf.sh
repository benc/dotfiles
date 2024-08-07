#!/bin/bash
echo "🔧 Configure ASDF..."

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

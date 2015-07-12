function code --description 'Open Visual Studio Code'
  if test -d "/Applications/Visual Studio Code.app"
    "/Applications/Visual Studio Code.app/Contents/MacOS/Electron" $argv
  else
    echo "No Visual Studio Code installation found"
  end
end

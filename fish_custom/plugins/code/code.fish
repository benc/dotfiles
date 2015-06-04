function code --description 'Open Visual Studio Code'
  if test -d "/Applications/Visual Studio Code.app"
    open -a "/Applications/Visual Studio Code.app" $argv
  else
    echo "No Visual Studio Code installation found"
  end
end

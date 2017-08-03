# The purpose of this script is to install the dependencies of LAS from npm, then start the server

#!/bin/bash

# If given a -f argument to force (re)install
FORCE_REINSTALL="false"
while getopts ":f:" opt; do
  case $opt in
    :)
      echo "Force installing..."
      FORCE_REINSTALL="true"
      ;;
  esac
done

# If no .LAS_status file, or force reinstall is selected
if [ "$FORCE_REINSTALL" == "true" ] || [ ! -f .LAS_status ]; then

  # Install NodeJS
  # Checks for and uses brew or apt-get. Else may use https://gist.github.com/isaacs/579814
  
  # Mac OS
  if hash brew 2>/dev/null; then
    echo "Installing Node with homebrew"
    brew install node
  else
    # Ubuntu/Debian
    if hash apt-get 2>/dev/null; then
      echo "Installing Node with apt-get"
      curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
      sudo apt-get install -y nodejs
    else
      # Enterprise Linus (e.g. Amazon Linux)
      if hash yum 2>/dev/null; then
        echo "Installing Node with yum"
        curl --silent --location https://rpm.nodesource.com/setup_8.x | sudo bash -
        sudo yum -y install nodejs
      fi
    fi
  fi

  # Install npm dependencies
  echo Installing dependencies from npm
  npm install
  npm install webpack -g

  # Add/update hidden status file
  touch .LAS_status
  echo "Latest Update:" > .LAS_status
  echo `date` > .LAS_status

  # Build bundles
  echo Bundling React components
  webpack
fi

# Start server
echo Starting LiveAPI Server
npm start

exit

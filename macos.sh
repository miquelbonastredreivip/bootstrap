#!/bin/sh

if [ -z "$1" ] ; then
  echo "We need IP for the saltmaster server"
  exit
fi

ADM_USER="$( id -un )"
SALT_HOST="$1"

echo "Bootstrapping macos with user='${ADM_USER}' and salt='${SALT_HOST}'"
echo "(Enter to continue, Ctrl-C to exit)"
read line

#
# enable SSH access
#
sudo systemsetup -setremotelogin on
sudo dseditgroup -o create -q com.apple.access_ssh
sudo dseditgroup -o edit -a "${ADM_USER}" -t user com.apple.access_ssh

#
# add salt server to host file
#

echo "${SALT} salt" >> /etc/hosts

#
# Install homebrew
#
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#
# Install and launch salt-minion
#
brew install saltstack
sudo salt-minion -d


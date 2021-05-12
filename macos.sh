#!/bin/sh
#
# $1 - saltmaster IP (mandatory)
# $2 - hostname for this machine (optional)
#
if [ -z "$1" ] ; then
  echo "We need IP for the saltmaster server"
  exit
fi

if [ -n "$2" ] ; then
  THIS_HOST="$2"
else
  info="MacOS-$(sw_vers -productVersion)-$(date "+%Y%m%d")"
  THIS_HOST="$( echo ${info} )"
fi

ADM_USER="$( id -un )"
SALT_HOST="$1"


echo "Bootstrapping macos with:"
echo "  user='${ADM_USER}' salt='${SALT_HOST}' minion_id='${THIS_HOST}'"
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
if ! grep -q -e "^${SALT}  *salt *$" ; then
  sudo bash -c "echo '${SALT} salt' >> /etc/hosts"
fi

#
# Install homebrew
#
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#
# Install and launch salt-minion
#

#
# ("brew install salt" has problems)
#
# brew install salt
# sudo salt-minion -d

# Install saltstack using bootstrap
# (https://repo.saltproject.io/)
curl -fsSL https://bootstrap.saltproject.io -o install_salt.sh
sudo sh install_salt.sh -P -x python3


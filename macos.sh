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

echo "Enabling SSH access:"
sudo systemsetup -setremotelogin on
sudo dseditgroup -o create -q com.apple.access_ssh
sudo dseditgroup -o edit -a "${ADM_USER}" -t user com.apple.access_ssh

echo "Adding salt server to host file:"

if ! grep -q -e "^${SALT_HOST}  *salt *$" /etc/hosts ; then
  sudo bash -c "echo '${SALT_HOST} salt' >> /etc/hosts"
fi

echo "Installing homebrew:"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# ("brew install salt" has some problems)
#
# brew install salt
# sudo salt-minion -d

echo "Installing and launching salt-minion:"
echo "(using bootstrap)"

curl -fsSL https://bootstrap.saltproject.io -o install_salt.sh
sudo sh install_salt.sh -P -x python3


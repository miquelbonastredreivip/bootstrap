#!/bin/sh
#
# ToDo: ntp
# ToDo: add salt IP as option not in hosts
#
#
function usage() {
cat <<EOF

Usage:

URL="https://raw.githubusercontent.com/miquelbonastredreivip/bootstrap/master/macos.sh"
curl -fsSL ${URL} -o macos.sh
sh macos.sh saltmasterIP [ hostname_for_this_machine ]

# $1 - saltmaster IP (mandatory)
# $2 - hostname for this machine (optional)

EOF
}

if [ -z "$1" ] ; then
  echo "We need IP for the saltmaster server"
  usage
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

echo "Exec harmless sudo id to enter password:"
sudo id -a

echo "Installing and launching salt-minion:"
echo "(using bootstrap)"

curl -fsSL https://bootstrap.saltproject.io -o install_salt.sh
sudo sh install_salt.sh -P -x python3 -i "${THIS_HOST}" -A ${SALT_HOST}

exit


echo "Create ssh group:"
sudo dseditgroup -o create -q com.apple.access_ssh

echo "Add user to ssh group:"
sudo dseditgroup -o edit -a "${ADM_USER}" -t user com.apple.access_ssh

echo "Enabling SSH access:"
sudo systemsetup -setremotelogin on

echo "Enabling SSH access (alternate method):"
sudo sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist

echo "Adding salt server to host file:"

if ! grep -q -e "^${SALT_HOST}  *salt *$" /etc/hosts ; then
  sudo bash -c "echo '${SALT_HOST} salt' >> /etc/hosts"
else
  echo "(Already there)"
fi



echo "Installing homebrew:"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"



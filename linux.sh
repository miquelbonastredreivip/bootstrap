#!/bin/sh
#
# This script mainly installs salt-minion.
#
# It also makes some configurations to facilitate administration
# in case salt-minion is not able to connect to salt-master.
#
#
usage() {
cat <<EOF

Usage:

URL="https://raw.githubusercontent.com/miquelbonastredreivip/bootstrap/master/linux.sh"
curl -fsSL ${URL} -o linux.sh
sh linux.sh saltmasterIP [ hostname_for_this_machine ]

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
  info="Linux-$( lsb_release -s -i -r | tr " " "-" )-$(date "+%Y%m%d")"
  THIS_HOST="$( echo ${info} )"
fi

ADM_USER="$( id -un )"
SALT_HOST="$1"


echo "Bootstrapping linux with:"
echo "  user='${ADM_USER}' salt='${SALT_HOST}' minion_id='${THIS_HOST}'"
echo "(Enter to continue, Ctrl-C to exit)"
read line

echo "Exec harmless sudo id to enter password:"
sudo id -a

echo "Installing and launching salt-minion:"
echo "(using bootstrap)"

curl -fsSL https://bootstrap.saltproject.io -o install_salt.sh
sudo sh install_salt.sh -P -x python3 -i "${THIS_HOST}" -A ${SALT_HOST}

#
# All this is optional:
#

echo "Adding salt server to host file:"

if ! grep -q -e "^${SALT_HOST}  *salt *$" /etc/hosts ; then
  sudo bash -c "echo '${SALT_HOST} salt' >> /etc/hosts"
else
  echo "(Already there)"
fi



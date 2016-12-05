#!/bin/sh

set -e

if ! hash apt-get 2>/dev/null; then
	echo "This script requires a Debian based distribution."
	exit 1
fi

if [ "$(id -u)" -ne "0" ]; then
	echo "This script requires root."
	exit 1
fi

sudo add-apt-repository -y ppa:nowrep/qupzilla
apt-get -y update
apt-get -y --no-install-recommends install qupzilla


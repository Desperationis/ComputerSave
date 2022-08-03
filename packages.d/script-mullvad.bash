#!/bin/bash

# Installation from https://github.com/neovim/neovim/releases/


FILE="https://mullvad.net/download/app/deb/latest/"
DEBNAME="mullvad.deb"

# Install
if [ $REMOVE -eq 0 ] 
then
	tmpdir=$(mktemp -d)
	if ! wget "$FILE" -O $tmpdir/$DEBNAME
	then
		echo -e "\033[0;31mERROR: Unable to download mullvad.\033[0m"
		read ans
		exit 1
	fi

	sudo apt-get install $tmpdir/$DEBNAME
fi

if [ $REMOVE -eq 1 ]
then
	sudo apt-get remove --purge mullvad-vpn
fi

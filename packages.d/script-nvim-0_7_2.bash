#!/bin/bash

# Installation from https://github.com/neovim/neovim/releases/


FILE="https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb"
CHECKFILE="https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.deb.sha256sum"
DEBNAME="nvim-linux64.deb"
CHECKNAME="nvim-linux64.check"

# Install
if [ $REMOVE -eq 0 ] 
then
	tmpdir=$(mktemp -d)
	if ! wget "$FILE" -O $tmpdir/$DEBNAME
	then
		echo -e "\033[0;31mERROR: Unable to download nvim.\033[0m"
		read ans
		exit 1
	fi

	if ! wget "$CHECKFILE" -O $tmpdir/$CHECKNAME
	then
		echo -e "\033[0;31mERROR: Unable to download nvim checksum.\033[0m"
		read ans
		exit 1
	fi

	RAWCHECKSUM=$(sha256sum $tmpdir/$DEBNAME | cut -d " " -f 1) 

	if ! cat "$tmpdir/$CHECKNAME" | cut -d " " -f 1 | grep "$RAWCHECKSUM"
	then
		echo -e "\033[0;31mERROR: nvim checksum is NOT identical. Quitting.\033[0m"
		read ans
		exit 1
	fi

	sudo apt-get install $tmpdir/$DEBNAME
fi

if [ $REMOVE -eq 1 ]
then
	sudo apt-get remove --purge nvim
fi

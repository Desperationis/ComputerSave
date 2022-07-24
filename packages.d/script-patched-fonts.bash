#!/bin/bash

# Installation from https://github.com/neovim/neovim/releases/

LINK="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/UbuntuMono/Regular/complete/Ubuntu%20Mono%20Nerd%20Font%20Complete.ttf"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
FONT_PATH=$SCRIPT_DIR/../patched-fonts

# Install
if [ $REMOVE -eq 0 ] 
then
	mkdir -p "$FONT_PATH"

	if ! wget "$LINK" -P "$FONT_PATH"
	then
		echo -e "\033[0;31mERROR: Unable to download $LINK.\033[0m"
		read ans
		exit 1
	fi

	echo -e "\033[0;92mPatched Fonts were downloaded to $FONT_PATH. Follow your specific distro's guide to install.\033[0m"
fi

# No REMOVE as fonts aren't actually installed

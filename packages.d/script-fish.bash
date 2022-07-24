#!/bin/bash

# fish install from https://github.com/fish-shell/fish-shell
# fisher install from https://github.com/jorgebucaran/fisher

# Install
if [ $REMOVE -eq 0 ] 
then
	if sudo apt-add-repository ppa:fish-shell/release-3
	then
		sudo apt-get update
		sudo apt-get install fish
	fi

	# Install plugins. `fisher` only exists inside of a fish shell
	if ! which fisher && which fish
	then
		fish -c "curl -sL https://git.io/fisher | source; fisher install jorgebucaran/fisher; fisher install edc/bass"
	elif ! which fish
	then
		echo -e "\033[0;31mERROR: fish was not installed; cannot install plugins. \033[0m"
		read ans
	fi
fi

if [ $REMOVE -eq 1 ]
then
	sudo apt-add-repository -r ppa:fish-shell/release-3
	fish -c "fisher remove edc/bass; fisher remove jorgebucaran/fisher"
	sudo apt-get remove --purge fish
fi

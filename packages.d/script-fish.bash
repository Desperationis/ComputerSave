#!/bin/bash

# Install
if [ $REMOVE -eq 0 ] 
then
	if sudo apt-add-repository ppa:fish-shell/release-3
	then
		sudo apt-get update
		sudo apt-get install fish

	fi

	# Install plugins. `fisher` only exists inside of a fish shell
	if ! which fisher
	then
		fish -c "curl -sL https://git.io/fisher | source; fisher install jorgebucaran/fisher; fisher install edc/bass"
	fi
fi

if [ $REMOVE -eq 1 ]
then
	sudo apt-add-repository -r ppa:fish-shell/release-3
	fish -c "fisher remove edc/bass; fisher remove jorgebucaran/fisher"
	sudo apt-get remove --purge fish
fi

#!/bin/bash

if sudo apt-add-repository ppa:fish-shell/release-3
then
	sudo apt-get update
	sudo apt-get install fish

fi

# Install plugins
if ! which fisher
then
	fish -c "curl -sL https://git.io/fisher | source; fisher install jorgebucaran/fisher; fisher install edc/bass"
fi


#!/bin/bash

if ! [[ which nvim ]] 
then
	echo "Error: nvim not found."
	exit 1
fi


if ! [[ -e ~/.config/nvim/init.lua ]]
then
	mkdir -p ~/.config/nvim
	cp init.lua ~/.config/nvim/
fi


if ! [[ -d  ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]]
then
	git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

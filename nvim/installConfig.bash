#!/bin/bash

if ! which nvim > /dev/null
then
	echo "Error: nvim not found."
	exit 1
fi


if ! [[ -e ~/.config/nvim/init.lua ]]
then
	mkdir -p ~/.config/nvim/
	cp init.lua ~/.config/nvim/
fi


if ! [[ -d  ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]]
then
	git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

nvim +PackerCompile +PackerInstall

if ! which npm > /dev/null
then
	echo "Error: npm not found."
	exit 1
fi

if ! which n 
then
	npm install n -g
fi

echo "NOTE: Do you have the latest version of nodejs? Make sure you ran \"n stable\" and restarted the tty."
read ans
npm install -g pyright
npm install -g bash-language-server

if ! sudo apt-get install clangd-12
then
	if ! sudo apt-get install clangd-11
	then
		echo "Error: Compatible version of clang not found."
	fi
fi

npm +"LspInstall clangd"

sudo apt-get install python3-venv

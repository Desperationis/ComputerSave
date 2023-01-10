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


if ! which npm > /dev/null
then
	echo "Error: npm not found."
	exit 1
fi

if ! which n > /dev/null
then
	sudo npm install n -g
fi

echo -e "\033[0;31mNOTE: Do you have the latest version of nodejs? Make sure you ran \"sudo n stable\" (already installed) and restarted the tty.\033[0;31m"
read ans
sudo npm install -g pyright
sudo npm install -g bash-language-server

if ! sudo apt-get install clangd-12
then
	if ! sudo apt-get install clangd-11
	then
		echo "Error: Compatible version of clang not found."
	fi
fi

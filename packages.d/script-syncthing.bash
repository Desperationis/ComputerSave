#!/bin/bash

# Source from https://apt.syncthing.net/

# Install
if [ $REMOVE -eq 0 ] 
then
	if ! sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
	then
		echo -e "\033[0;31mERROR: Could not install syncthing release key.\033[0m"
		read ans
		exit 1
	fi

	if ! echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
	then
		echo -e "\033[0;31mERROR: Could not install syncthing apt archive.\033[0m"
		read ans
		exit 1
	fi

	sudo apt-get update 
	sudo apt-get install syncthing 
fi

if [ $REMOVE -eq 1 ]
then
	sudo rm -rf /usr/share/keyrings/syncthing-archive-keyring.gpg
	sudo rm -rf /etc/apt/sources.list.d/syncthing.list
	sudo apt-get remove --purge syncthing
fi

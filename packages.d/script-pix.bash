#!/bin/bash

# Source from some post I saw long ago

# Install
if [ $REMOVE -eq 0 ] 
then
	if sudo add-apt-repository ppa:savoury1/xapps
	then
		sudo apt-get update
		sudo apt-get install pix
	fi
fi

if [ $REMOVE -eq 1 ]
then
	sudo apt-add-repository -r ppa:savoury1/xapps
	sudo apt-get remove --purge pix
fi

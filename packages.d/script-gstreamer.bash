#!/bin/bash

packages=(
	gstreamer1.0-plugins-base
	gstreamer1.0-plugins-good
	gstreamer1.0-plugins-bad
	gstreamer1.0-plugins-ugly
	gstreamer1.0-libav
	gstreamer1.0-tools
	gstreamer1.0-x
	gstreamer1.0-alsa
	gstreamer1.0-gl
	gstreamer1.0-gtk3
	gstreamer1.0-qt5
	gstreamer1.0-pulseaudio
	gstreamer1.0-adapter-pulseeffects
	gstreamer1.0-autogain-pulseeffects
	gstreamer1.0-clutter-3.0
	gstreamer1.0-convolver-pulseeffects
	gstreamer1.0-crystalizer-pulseeffects
	gstreamer1.0-espeak
	gstreamer1.0-fdkaac
	gstreamer1.0-nice
	gstreamer1.0-omx-bellagio-config
	gstreamer1.0-omx-generic
	gstreamer1.0-omx-generic-config
	gstreamer1.0-packagekit
	gstreamer1.0-pipewire
	gstreamer1.0-pocketsphinx
	gstreamer1.0-python3-plugin-loader
	gstreamer1.0-vaapi
	libgstreamer1.0-dev
	libgstreamer-plugins-base1.0-dev
	libgstreamer-plugins-bad1.0-dev
)

# Install
if [ $REMOVE -eq 0 ] 
then
	sudo apt-get install ${packages[@]}
fi

if [ $REMOVE -eq 1 ]
then
	echo -e "\033[0;31mNOTE: Be EXTRA careful in uninstalling. Packages will be uninstalled one by one, and it is YOUR job to make sure it won't accidentally remove a few dozen core packages.\033[0m"
	read ans
	for package in ${packages[@]}
	do
		sudo apt-get remove --purge $package
	done
fi

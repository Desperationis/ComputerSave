#!/bin/bash

# yt-dlp install from https://github.com/yt-dlp/yt-dlp#installation

# Install
if [ $REMOVE -eq 0 ] 
then
	pip3 install yt-dlp
fi

if [ $REMOVE -eq 1 ]
then
	pip3 uninstall yt-dlp
fi

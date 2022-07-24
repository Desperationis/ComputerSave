#!/bin/bash

packages=(
	pygame
	pyautogui
	PythonFileLibrary
	psscraper
	bs4
	requests
	PyYAML
	selenium
)

# Install
if [ $REMOVE -eq 0 ] 
then
	pip3 install ${packages[@]}
fi

if [ $REMOVE -eq 1 ]
then
	pip3 uninstall ${packages[@]}
fi

install() {
	echo "\n\n\nInstalling $1..."
	if ! sudo apt-get install -y $1
	then
		echo "$1 was not a valid package."
		exit 1
	fi
}

sudo apt-get update
sudo apt-get -y upgrade

install python3
install python
install git
install g++
install cmake
install cmake-curses-gui
install curl
install wget

if ! pix --version
then
	sudo add-apt-repository -y ppa:savoury1/xapps
	sudo apt update
	sudo apt install -y pix
fi

install vim
install okular
install keepass2
install obs-studio
install xclip
install texlive-full
install tree
install python3
install python3-pip
install npm
install nodejs
install gparted
install vlc
install clementine
install vlc
install gdb
install libc6-dev
install libc-dev-bin
install libncurses-dev
install libsdl2-dev
install libsdl2-ttf-dev
install libsdl2-image-dev
install libssl-dev
install dos2unix

if ! youtube-dl --version
then
	sudo curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
	sudo chmod a+rx /usr/local/bin/youtube-dl
fi

if ! google-chrome-stable --version
then
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
	install ./google-chrome-stable_current_amd64.deb
	rm google-chrome-stable_current_amd64.deb
fi

if ! type discord
then
	wget -O ./discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
	install ./discord.deb
	rm ./discord.deb
fi

if ! type anki
then
	(
	wget -O anki.tar.bz2 https://github.com/ankitects/anki/releases/download/2.1.49/anki-2.1.49-linux.tar.bz2
	tar -xf anki.tar.bz2
	cd anki-2.1.49-linux/
	chmod +x ./install.sh
	sudo ./install.sh
	)

	rm anki.tar.bz2
	rm -rf anki-2.1.49-linux
fi


sudo apt-get install -y gstreamer1.0*

install libgstreamer-plugins-base1.0-dev
install pkg-config
install build-essential
install python3-pip

pip3 install pygame pyautogui PythonFileLibrary psscraper

# Misc:
# JDownloader 2
# VNC Viewer


# Remember! checkinstall can be used to wrap source code (with a makefile) into a single .deb

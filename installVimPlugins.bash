if [[ -e .vimrc ]]
then
	mv .vimrc ~/.vimrc
fi

if ! [[ -d ~/.vim/bundle/Vundle.vim ]]
then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

vim +PluginInstall +qall

if [[ -d ~/.vim/bundle/YouCompleteMe ]]
then
	cd ~/.vim/bundle/YouCompleteMe
	python3 install.py --all

else
	echo "ERROR: Could not detect YouCompleteMe in ~/.vim/bundle"
	exit 1
fi

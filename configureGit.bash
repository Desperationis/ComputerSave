# Make sure you don't must personal info in here lmao

if which nvim > /dev/null
then
	git config --global core.editor nvim
fi

if which vim > /dev/null
then
	git config --global core.editor vim
fi

if which nano > /dev/null
then
	git config --global core.editor nano
fi

git config --global user.name "Desperationis"
git config --global user.email "smarttdiego@gmail.com"

if ! [[ -f ~/.ssh/id_ed25519 ]]
then
	ssh-keygen -t ed25519 -C "smarttdiego@gmail.com"
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_ed25519
fi

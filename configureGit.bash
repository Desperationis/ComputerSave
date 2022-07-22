# Make sure you don't must personal info in here lmao

git config --global core.editor nvim
git config --global user.name "Desperationis"
git config --global user.email "smarttdiego@gmail.com"

if ! [[ -f ~/.ssh/id_ed25519 ]]
then
	ssh-keygen -t ed25519 -C "smarttdiego@gmail.com"
	eval "$(ssh-agent -s)"
	ssh-add ~/.ssh/id_ed25519
fi

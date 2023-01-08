echo -e "\033[0;31mAre you sure you want to clean your neovim config? This will completely wipe neovim and install init.lua again.\033[0;31m"
read ans

rm -rf ~/.config/nvim/init.lua
rm -rf ~/.local/share/nvim/
cp init.lua ~/.config/nvim/

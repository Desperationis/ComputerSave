# Nvim init.lua instructions
1. Install [packer](https://github.com/wbthomason/packer.nvim)
2. Run `:PackerCompile` then `:PackerInstall`
3. Install [pyright](https://github.com/microsoft/pyright) with `sudo npm install -g pyright`
4. Install [clangd](https://clangd.llvm.org/installation.html) with `sudo apt-get install clangd-12` or `sudo apt-get install clangd-11` 
5. Run `:LspInstall clangd`
6. `sudo apt-get install python3-venv` -> Dependency for COQnow (just trust me I spent an hour on this)
7. Profit

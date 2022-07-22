# Nvim init.lua instructions
1. Install [packer](https://github.com/wbthomason/packer.nvim)
2. Run `:PackerCompile` then `:PackerInstall`
3. Get the latest version of nodejs by installing them: `sudo apt-get install nodejs npm`, then run `npm install n -g` and finally `n stable` or `n latest` to get the latest version of nodejs. 
4. Install [pyright](https://github.com/microsoft/pyright) with `npm install -g pyright`. 
5. Install [bashls](https://github.com/bash-lsp/bash-language-server) with `npm i -g bash-language-server`.
6. Install [clangd](https://clangd.llvm.org/installation.html) with `sudo apt-get install clangd-12`
7. Run `:LspInstall clangd` to help find it
8. `sudo apt-get install python3-venv` -> Dependency for COQnow
9. Profit

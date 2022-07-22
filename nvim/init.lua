local set = vim.opt

set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.linebreak = true
set.backspace = "indent,eol,start"
set.guicursor="n-v-c-sm:ver25,i-ci-ve:ver25,r-cr-o:hor20"

require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'preservim/nerdtree'
	use 'tpope/vim-fugitive'
	use 'williamboman/nvim-lsp-installer'
	use 'neovim/nvim-lspconfig'
	use 'ms-jpq/coq_nvim'
	use 'lewis6991/gitsigns.nvim'
end)

require('plugin_config')

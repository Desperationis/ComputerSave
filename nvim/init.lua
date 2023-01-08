-- Install packer automatically if it is not installed
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end



local set = vim.opt

set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.linebreak = true
set.backspace = "indent,eol,start"
set.guicursor="n-v-c-sm:ver25,i-ci-ve:ver25,r-cr-o:hor20"

function gitsigns()
	require('gitsigns').setup{
	  on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, l, r, opts)
		  opts = opts or {}
		  opts.buffer = bufnr
		  vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map('n', ']c', function()
		  if vim.wo.diff then return ']c' end
		  vim.schedule(function() gs.next_hunk() end)
		  return '<Ignore>'
		end, {expr=true})

		map('n', '[c', function()
		  if vim.wo.diff then return '[c' end
		  vim.schedule(function() gs.prev_hunk() end)
		  return '<Ignore>'
		end, {expr=true})

		-- Actions
		map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
		map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
		map('n', '<leader>hS', gs.stage_buffer)
		map('n', '<leader>hu', gs.undo_stage_hunk)
		map('n', '<leader>hR', gs.reset_buffer)
		map('n', '<leader>hp', gs.preview_hunk)
		map('n', '<leader>hb', function() gs.blame_line{full=true} end)
		map('n', '<leader>tb', gs.toggle_current_line_blame)
		map('n', '<leader>hd', gs.diffthis)
		map('n', '<leader>hD', function() gs.diffthis('~') end)
		map('n', '<leader>td', gs.toggle_deleted)

		-- Text object
		map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
	  end
	}
end

function lsp()
	require("nvim-lsp-installer").setup{}
	require'lspconfig'.clangd.setup{}
	require'lspconfig'.pyright.setup{}
	require'lspconfig'.bashls.setup{}
end


require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'preservim/nerdtree'
	use 'tpope/vim-fugitive'
	use 'williamboman/nvim-lsp-installer'
	use 'neovim/nvim-lspconfig'
	use 'ms-jpq/coq_nvim'
	use 'lewis6991/gitsigns.nvim'
	use { "catppuccin/nvim", as = "catppuccin" }

	if is_bootstrap then
		require('packer').sync()
	end
end)

require("catppuccin").setup({
	dim_inactive = {
        enabled = true,
        shade = "dark",
        --percentage = 0.15,
        percentage = 0.5,
    },
	term_colors=true
})


if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

vim.o.mouse = ""
vim.wo.number = true
vim.cmd [[ colorscheme catppuccin ]]


-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

pcall(gitsigns)
pcall(lsp)

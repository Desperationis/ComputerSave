local set = vim.opt

set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
set.linebreak = true
set.backspace = "indent,eol,start"
set.guicursor="n-v-c-sm:ver25,i-ci-ve:ver25,r-cr-o:hor20"

function gitsigns()
	if packer_plugins['gitsigns'] then
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
end

function lspinstaller()
	if packer_plugins['nvim-lsp-installer'] then
		require("nvim-lsp-installer").setup{}
	end
end

function lsp()
	if packer_plugins['nvim-lspconfig'] then
		require'lspconfig'.clangd.setup{}
		require'lspconfig'.pyright.setup{}
		require'lspconfig'.bashls.setup{}
	end
end


require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'preservim/nerdtree'
	use 'tpope/vim-fugitive'
	use { 'williamboman/nvim-lsp-installer', config = lspinstaller }
	use { 'neovim/nvim-lspconfig', config = lsp }
	use 'ms-jpq/coq_nvim'
	use { 'lewis6991/gitsigns.nvim', config = gitsigns }
end)


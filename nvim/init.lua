-- Install packer automatically if it is not installed
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end



require('packer').startup(function()
	use 'wbthomason/packer.nvim'

	use { -- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		requires = {
		  -- Automatically install LSPs to stdpath for neovim
		  'williamboman/mason.nvim',
		  'williamboman/mason-lspconfig.nvim',

		  -- Useful status updates for LSP
		  'j-hui/fidget.nvim',

		  -- Additional lua configuration, makes nvim stuff amazing
		  'folke/neodev.nvim',
		},
	  }

	use { -- Autocompletion
		'hrsh7th/nvim-cmp',
		requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
	  }

	use 'preservim/nerdtree'

	use 'tpope/vim-fugitive' -- git
	use 'lewis6991/gitsigns.nvim' -- Visualize git changes on the side

	use { "catppuccin/nvim", as = "catppuccin" } -- Colorscheme

	if is_bootstrap then
		require('packer').sync()
	end
end)



if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end


-- Set Preferences
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.linebreak = true
vim.opt.backspace = "indent,eol,start"
vim.opt.guicursor="n-v-c-sm:ver25,i-ci-ve:ver25,r-cr-o:hor20"

vim.o.mouse = ""
vim.wo.number = true

-- vim.o.updatetime = 250 -- This is how many ms it takes of inactivity to write to swap file
vim.wo.signcolumn = "yes"

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'


-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})
 



-- ANYTHING BELOW IS SETUP FOR ALL PACKAGES

require("catppuccin").setup({
	dim_inactive = {
        enabled = true,
        shade = "dark",
        --percentage = 0.15,
        percentage = 0.5,
    },
	term_colors=true,
	integrations = {
		cmp = true,
		gitsigns = true,
		--nvimtree = true,
		--telescrope = true,
		fidget = true,
		mason = true,
	}
})
vim.cmd [[ colorscheme catppuccin ]]

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

-- Configure sumneko_lua to have nvim lua stuff
require("neodev").setup()


-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
   clangd = {},
   pyright = {},
   sumneko_lua = {},
   bashls = {},
   arduino_language_server = {},
   asm_lsp = {},
   cmake = {},
   cssls = {},
   html = {},
   dockerls = {},
   jdtls = {},
   jsonls = {},
   quick_lint_js = {},
   marksman = {}
}

require("mason").setup()


-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

-- Auto setup all LSP's whenever Mason installs a package
mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup{}
  end,
}

-- Turn on lsp status information
require('fidget').setup({
	window = { -- This is for catppuccin
		blend = 0,
	},
})



-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

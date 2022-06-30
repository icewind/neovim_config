-- Automatically install packer if it is not installed at the following path
local fn = vim.fn

local packer_install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap = nil

if fn.empty(fn.glob(packer_install_path)) > 0 then
	packer_bootstrap = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		packer_install_path,
	})
end

-- Split plugin configuration into different files in the `setup` folder.
local function get_config(name)
	return string.format('require("setup.%s")', name)
end

-- Automatically compile packer once the list of plugins changes
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Add plugins
require("packer").startup(function(use)
	use("wbthomason/packer.nvim") -- Package manager

	-- Need to check the following plugings. I got used to git cli so will see if they are needed
	-- use 'tpope/vim-fugitive' -- Git commands in nvim
	-- use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github

	-- Favorite color themes
	use("sainnhe/everforest")
	-- use("sainnhe/sonokai")
	-- use("arcticicestudio/nord-vim")

	use("tpope/vim-commentary") -- Create/remove comments using gc

	-- Better buffer close functionality
	use("moll/vim-bbye")

	-- Select all the things with a nice UI
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = get_config("telescope"),
	})
	-- Use telescope instead of the standard ui.select
	use({ "nvim-telescope/telescope-ui-select.nvim" })

	use({
		"nvim-treesitter/nvim-treesitter",
		config = get_config("treesitter"),
		run = ":TSUpdate",
	})
	use("nvim-treesitter/nvim-treesitter-textobjects")

	-- File manager
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
		config = get_config("tree"),
	})

	-- Status line
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = get_config("lualine"),
	})

	-- And buffers line
	use({
		"akinsho/bufferline.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = get_config("bufferline"),
	})

	-- TODO: Replace this vim lua analog once it will be as functional
	use("tpope/vim-surround")

	use({
		"phaazon/hop.nvim",
		event = "BufReadPre",
		config = get_config("hop"),
	})

	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		event = "BufReadPre",
		config = get_config("gitsigns"),
	})

	-- Show indentation level with virtual text
	use({ "lukas-reineke/indent-blankline.nvim", config = get_config("indent-blankline") })

	-- Fancy notifications
	use({
		"rcarriga/nvim-notify",
		config = get_config("notify"),
	})

	-- Autocompletion and LSP
	use({
		"neovim/nvim-lspconfig",
		config = get_config("lspconfig"),
	})

	use({
		"hrsh7th/nvim-cmp",
		config = get_config("cmp"),
	})

	-- Get completions from the LSP
	use("hrsh7th/cmp-nvim-lsp")

	-- Add kind icons into completion dropdown
	use("onsails/lspkind-nvim")

	-- Get completions from the current buffer
	use("hrsh7th/cmp-buffer")

	use({ "jose-elias-alvarez/null-ls.nvim", config = get_config("nullls") })

	-- Show function signature on type
	use({
		"ray-x/lsp_signature.nvim",
		config = get_config("lspsignature"),
	})

	use("mattn/emmet-vim")

	use({
		"windwp/nvim-autopairs",
		config = get_config("autopairs"),
	})

	use({
		"L3MON4D3/LuaSnip",
		config = get_config("luasnip"),
	})

	use("editorconfig/editorconfig-vim")

	-- Snippets and integration of snippets and cmp
	use("saadparwaiz1/cmp_luasnip")

	use("rafamadriz/friendly-snippets")

	-- Display code issues
	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = get_config("trouble"),
	})

	-- Lua development(mainly for neovim)
	use("tjdevries/nlua.nvim") -- Language server for Lua
	use("euclidianAce/BetterLua.vim") -- Better syntax highlight
	use("tjdevries/manillua.nvim") -- Folds for Lua code

	-- Markdown preview
	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && yarn install",
		ft = { "markdown" },
		cmd = "MarkdownPreview",
	})

	-- Svelte support
	use("leafOfTree/vim-svelte-plugin")

	-- Databases
	use({ "tpope/vim-dadbod" })
	use({ "kristijanhusak/vim-dadbod-ui" })
	use({ "kristijanhusak/vim-dadbod-completion" })

	-- The allmighty Prettier
	use({
		"prettier/vim-prettier",
		run = "yarn install",
		ft = { "javascript", "typescript", "css", "less", "scss", "graphql", "markdown", "vue", "html" },
	})

	-- Better rust development
	-- Initialization of this plugin takes place in the lsp config
	use({ "simrat39/rust-tools.nvim" })

	use({
		"nvim-neorg/neorg",
		ft = "norg",
		after = "nvim-treesitter", -- You may want to specify Telescope here as well
		config = get_config("neorg"),
	})

	-- Local plugins for machine-dependant extensions
	require("local_plugins")(use)

	-- Automatically setup packer configuration after the first install
	if packer_bootstrap then
		require("packer").sync()
	end
end)

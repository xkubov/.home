--
-- Setup plugins using Packer.
--

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

local configuration = function(use)
    use("wbthomason/packer.nvim") -- Packer can manage itself

    -- manages external editor tooling (LSP, DAP, linters, formatters)
    use({ "williamboman/mason.nvim" })
    use({ "williamboman/mason-lspconfig.nvim" })

    -- Linting & Formatting.
    use({
        "jose-elias-alvarez/null-ls.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    })

    use("neovim/nvim-lspconfig") -- Configurations for nvim LSP
    use("hrsh7th/nvim-cmp") -- Autocompletion plugin
    use("hrsh7th/cmp-nvim-lsp") -- LSP source for nvim-cmp
    use("mfussenegger/nvim-dap") -- Debugger
    use("saadparwaiz1/cmp_luasnip") -- Snippets source for nvim-cmp
    use("L3MON4D3/LuaSnip") -- Snippets plugin
    use("rstacruz/vim-closer") -- Closes brackets.

    -- Indentation guides.
    use("lukas-reineke/indent-blankline.nvim")

    -- Matches begin/close of many languages.
    -- e.g. if/fi in bash, function/end in lua, etc.
    use({
        "andymass/vim-matchup",
        setup = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    })

    -- View Markdown edits real time.
    use({
        "iamcco/markdown-preview.nvim",
        run = "cd app && npm install",
        setup = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    })

    -- Treesitter.
    use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

    -- File explorer.
    use({
        "nvim-tree/nvim-tree.lua",
        requires = {
            "nvim-tree/nvim-web-devicons",
        },
        tag = "nightly",
    })

    -- Replacement for UI for messages, cmdline & popup.
    use({
        "folke/noice.nvim",
        requires = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    })

    -- Fuzzy search
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.1",
        requires = { { "nvim-lua/plenary.nvim" } },
    })

    -- Sleak CMD line at the bottom.
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })

    -- Git
    use({ "tpope/vim-fugitive" })
    use({ "lewis6991/gitsigns.nvim" })

    -- A greeter.
    use({
        "goolord/alpha-nvim",
        requires = { "BlakeJC94/alpha-nvim-fortune" },
        config = function()
            require("alpha").setup(require("alpha.themes.dashboard").config)
        end,
    })

    -- Themes
    use({ "EdenEast/nightfox.nvim" })

    -- Comments
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    -- vimwiki
    use({ "vimwiki/vimwiki" })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end

    use({ "ThePrimeagen/vim-be-good" })
    use({ "github/copilot.vim" })
end

return require("packer").startup(configuration)

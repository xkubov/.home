--
-- Setup plugins using Lazy.nvim
--

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
    -- LSP Configuration
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            require("config.lsp").setup()
        end,
    },
    -- Mason: manages external editor tooling (LSP, DAP, linters, formatters)
    {
        "williamboman/mason.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "pyright",
                    "ruff",
                },
            })
        end,
    },

    -- Formatting is handled by the LSP servers themselves (ruff for Python).

    -- Autocompletion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",

    -- Snippets
    "L3MON4D3/LuaSnip",

    -- Indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {},
    },

    -- Enhanced matching
    {
        "andymass/vim-matchup",
        init = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "lua",
                    "markdown",
                    "python",
                    "rust",
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = function(lang, buf)
                        local max_filesize = 1024 * 1024 -- 1 MB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                    end,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },

    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- disable netrw at the very start of your init.lua (strongly advised)
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            -- set termguicolors to enable highlight groups
            vim.opt.termguicolors = true

            require("nvim-tree").setup({
                sort_by = "case_sensitive",
                view = {
                    width = 30,
                },
                renderer = {
                    group_empty = true,
                    highlight_git = false,
                },
                filters = {
                    dotfiles = false,
                },
                on_attach = function(bufnr)
                    local api = require("nvim-tree.api")

                    local function opts(desc)
                        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                    end

                    -- Default mappings
                    api.config.mappings.default_on_attach(bufnr)

                    -- Custom mappings
                    vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
                    vim.keymap.set('n', '<C-e>', '', opts(''))
                end,
            })
        end,
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local builtin = require("telescope.builtin")

            vim.keymap.set("n", "<leader>;", builtin.find_files, {})
            vim.keymap.set("n", "<leader>'", builtin.live_grep, {})
            vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
            vim.keymap.set("n", "gr", builtin.lsp_references, {})
            vim.keymap.set("n", "gd", builtin.lsp_definitions, {})
            vim.keymap.set("n", "gD", builtin.lsp_type_definitions, {})
            vim.keymap.set("n", "gi", builtin.lsp_implementations, {})
            vim.keymap.set("n", "gs", builtin.lsp_dynamic_workspace_symbols, {})
            vim.keymap.set("n", "gS", builtin.lsp_workspace_symbols, {})
        end,
    },

    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({
                options = {
                    icons_enabled = true,
                    theme = "nightfox",
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {},
            })
        end,
    },

    -- Git integration
    "tpope/vim-fugitive",
    {
        "lewis6991/gitsigns.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "│" },
                    change = { text = "│" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked = { text = "┆" },
                },
                signcolumn = true,
                numhl = false,
                linehl = false,
                word_diff = false,
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true,
                },
                attach_to_untracked = true,
                current_line_blame = false,
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = "eol",
                    delay = 1000,
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil,
                max_file_length = 40000,
                preview_config = {
                    border = "single",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
            })
        end,
    },

    -- Greeter/Dashboard
    {
        "goolord/alpha-nvim",
        dependencies = { "BlakeJC94/alpha-nvim-fortune" },
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            local splash_screen_banners = {
                {
                    "      ███╗   ███╗ █████╗  ██████╗ ██╗ ██████╗      ",
                    "      ████╗ ████║██╔══██╗██╔════╝ ██║██╔════╝      ",
                    "      ██╔████╔██║███████║██║  ███╗██║██║           ",
                    "      ██║╚██╔╝██║██╔══██║██║   ██║██║██║           ",
                    "      ██║ ╚═╝ ██║██║  ██║╚██████╔╝██║╚██████╗      ",
                    "      ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝ ╚═════╝      ",
                    "                                                   ",
                    " ██████╗ █████╗ ███╗   ██╗██╗   ██╗ █████╗ ███████╗",
                    "██╔════╝██╔══██╗████╗  ██║██║   ██║██╔══██╗██╔════╝",
                    "██║     ███████║██╔██╗ ██║██║   ██║███████║███████╗",
                    "██║     ██╔══██║██║╚██╗██║╚██╗ ██╔╝██╔══██║╚════██║",
                    "╚██████╗██║  ██║██║ ╚████║ ╚████╔╝ ██║  ██║███████║",
                    " ╚═════╝╚═╝  ╚═╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝  ╚═╝╚══════╝",
                },
                {
                    "▄█▄    ████▄ ██▄   ▄███▄       █    ▄█ █  █▀ ▄███▄     ",
                    "█▀ ▀▄  █   █ █  █  █▀   ▀      █    ██ █▄█   █▀   ▀    ",
                    "█   ▀  █   █ █   █ ██▄▄        █    ██ █▀▄   ██▄▄      ",
                    "█▄  ▄▀ ▀████ █  █  █▄   ▄▀     ███▄ ▐█ █  █  █▄   ▄▀   ",
                    "▀███▀        ███▀  ▀███▀           ▀ ▐   █   ▀███▀     ",
                    "                                        ▀              ",
                    "                                                       ",
                    "   ▄▄▄▄▀ ▄  █ ▄███▄       ██▄   ▄███▄      ▄   ▄█ █    ",
                    "▀▀▀ █   █   █ █▀   ▀      █  █  █▀   ▀      █  ██ █    ",
                    "    █   ██▀▀█ ██▄▄        █   █ ██▄▄   █     █ ██ █    ",
                    "   █    █   █ █▄   ▄▀     █  █  █▄   ▄▀ █    █ ▐█ ███▄ ",
                    "  ▀        █  ▀███▀       ███▀  ▀███▀    █  █   ▐     ▀",
                    "          ▀                               █▐           ",
                    "                                          ▐            ",
                },
                {
                    " ███▄    █  ▒█████     ▓█████   ██████  ▄████▄   ▄▄▄       ██▓███  ▓█████ ",
                    " ██ ▀█   █ ▒██▒  ██▒   ▓█   ▀ ▒██    ▒ ▒██▀ ▀█  ▒████▄    ▓██░  ██▒▓█   ▀ ",
                    "▓██  ▀█ ██▒▒██░  ██▒   ▒███   ░ ▓██▄   ▒▓█    ▄ ▒██  ▀█▄  ▓██░ ██▓▒▒███   ",
                    "▓██▒  ▐▌██▒▒██   ██░   ▒▓█  ▄   ▒   ██▒▒▓▓▄ ▄██▒░██▄▄▄▄██ ▒██▄█▓▒ ▒▒▓█  ▄ ",
                    "▒██░   ▓██░░ ████▓▒░   ░▒████▒▒██████▒▒▒ ▓███▀ ░ ▓█   ▓██▒▒██▒ ░  ░░▒████▒",
                    "░ ▒░   ▒ ▒ ░ ▒░▒░▒░    ░░ ▒░ ░▒ ▒▓▒ ▒ ░░ ░▒ ▒  ░ ▒▒   ▓▒█░▒▓▒░ ░  ░░░ ▒░ ░",
                    "░ ░░   ░ ▒░  ░ ▒ ▒░     ░ ░  ░░ ░▒  ░ ░  ░  ▒     ▒   ▒▒ ░░▒ ░      ░ ░  ░",
                    "   ░   ░ ░ ░ ░ ░ ▒        ░   ░  ░  ░  ░          ░   ▒   ░░          ░   ",
                    "         ░     ░ ░        ░  ░      ░  ░ ░            ░  ░            ░  ░",
                    "                                       ░                                  ",
                    "      █████▒██▀███   ▒█████   ███▄ ▄███▓    ██▒   █▓ ██▓ ███▄ ▄███▓       ",
                    "    ▓██   ▒▓██ ▒ ██▒▒██▒  ██▒▓██▒▀█▀ ██▒   ▓██░   █▒▓██▒▓██▒▀█▀ ██▒       ",
                    "    ▒████ ░▓██ ░▄█ ▒▒██░  ██▒▓██    ▓██░    ▓██  █▒░▒██▒▓██    ▓██░       ",
                    "    ░▓█▒  ░▒██▀▀█▄  ▒██   ██░▒██    ▒██      ▒██ █░░░██░▒██    ▒██        ",
                    "    ░▒█░   ░██▓ ▒██▒░ ████▓▒░▒██▒   ░██▒      ▒▀█░  ░██░▒██▒   ░██▒       ",
                    "     ▒ ░   ░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░ ▒░   ░  ░      ░ ▐░  ░▓  ░ ▒░   ░  ░       ",
                    "     ░       ░▒ ░ ▒░  ░ ▒ ▒░ ░  ░      ░      ░ ░░   ▒ ░░  ░      ░       ",
                    "     ░ ░     ░░   ░ ░ ░ ░ ▒  ░      ░           ░░   ▒ ░░      ░          ",
                    "              ░         ░ ░         ░            ░   ░         ░          ",
                    "                                                ░                         ",
                },
            }

            -- Set header
            dashboard.section.header.val = splash_screen_banners[math.random(1, #splash_screen_banners)]

            -- Set menu
            dashboard.section.buttons.val = {
                dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("f", "  > Find file", ":cd $HOME/projects | Telescope find_files<CR>"),
                dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
                dashboard.button("w", "  > Wiki", ":e ~/vimwiki/index.wiki<CR>"),
                dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
                dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
            }

            local fortune = require("alpha.fortune")
            dashboard.section.footer.val = fortune()

            -- Send config to alpha
            alpha.setup(dashboard.opts)

            -- Disable folding on alpha buffer
            vim.cmd([[
                autocmd FileType alpha setlocal nofoldenable
            ]])
        end,
    },

    -- Theme
    {
        "EdenEast/nightfox.nvim",
        config = function()
            require("nightfox").setup({
                options = {
                    transparent = true,
                    terminal_colors = true,
                    dim_inactive = false,
                },
            })

            vim.cmd("colorscheme nightfox")
        end,
    },

    -- Comments
    {
        "numToStr/Comment.nvim",
        opts = {},
    },

    -- Vimwiki
    "vimwiki/vimwiki",

    -- Additional plugins
    "mbbill/undotree",
}, {
    -- Lazy.nvim configuration options
    ui = {
        border = "rounded",
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

require("plugins")

vim.opt.autochdir = false
vim.opt.encoding = "utf-8"
vim.opt.mouse = "v"
vim.opt.ruler = true
vim.opt.hlsearch = true
vim.opt.wildmode = "longest,list"
vim.opt.laststatus = 2
vim.opt.relativenumber = true

vim.wo.number = true

local opts = { noremap = true, silent = true }

vim.g.mapleader = " "

vim.api.nvim_set_keymap("n", "<C-w>1", ":tabn 1<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>2", ":tabn 2<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>3", ":tabn 3<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>4", ":tabn 4<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>5", ":tabn 5<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>6", ":tabn 6<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>7", ":tabn 7<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>8", ":tabn 8<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>9", ":tabn 9<CR>", opts)

vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", opts)
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", opts)
vim.api.nvim_set_keymap("n", "<C-f>", "<C-f>zz", opts)
vim.api.nvim_set_keymap("n", "<C-b>", "<C-b>zz", opts)

vim.api.nvim_set_keymap("n", "th", ":tabfirst<CR>", opts)
vim.api.nvim_set_keymap("n", "tl", ":tabnext<CR>", opts)
vim.api.nvim_set_keymap("n", "th", ":tabprev<CR>", opts)
vim.api.nvim_set_keymap("n", "tt", ":tabedit<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>c", ":tabedit<CR>", opts)

vim.api.nvim_set_keymap("n", "<leader>s", ":set invspell spelllang=sk<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>e", ":set invspell spelllang=en_us<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader><space>", "<Ctrl-space>", opts)

vim.api.nvim_set_keymap("n", "<C-e>", ":NvimTreeToggle<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader><space>", ":VimwikiToggleListItem<CR>", opts)

vim.cmd([[
    imap <silent><script><expr> <C-l> copilot#Accept("\<CR>")
    let g:copilot_no_tab_map = v:true
    imap <silent> <C-j> <Plug>(copilot-next)
    imap <silent> <C-k> <Plug>(copilot-previous)
    imap <silent> <C-h> <Plug>(copilot-dismiss)
]])

vim.cmd([[
    autocmd Filetype c setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype cmake setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype conf setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype go setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype haskell setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype hocon setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype javascript setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype json setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype kotlin setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype lua setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype markdown setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype toml setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype html setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype jinja2 setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
    autocmd Filetype vimwiki setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
    autocmd Filetype yaml setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2
]])

require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all" (the four listed parsers should always be installed)
    ensure_installed = "all",
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    indent = {
        enable = true,
    },
    highlight = {
        -- `false` will disable the whole extension
        enable = true,

        disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            return ok and stats and stats.size > max_filesize
        end,

        additional_vim_regex_highlighting = false,
    },
})

-- Setup mason

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "pyright",
    },
    automatic_installation = true,
})

-- Setup linting & formatting

local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local is_python = function()
    return vim.bo.filetype == "python"
end

local is_range_formatting = false

local turn_on_codespell = true

null_ls.setup({
    debug = true,
    on_attach = function(client, bufnr)
        -- I needed to temporarily turn off support for Python autoformatting.
        -- if not is_python() and client.supports_method("textDocument/formatting") then
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr })
                end,
            })
        end
    end,
    sources = {
        null_ls.builtins.formatting.shfmt,
        null_ls.builtins.completion.spell,
        null_ls.builtins.formatting.codespell.with({
            runtime_condition = function(params)
                return turn_on_codespell
            end,
        }),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.autopep8,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.yapf.with({
            runtime_condition = function(params)
                local ranged = is_range_formatting
                is_range_formatting = false
                return ranged
            end,
        }),
        -- null_ls.builtins.diagnostics.mypy,
        -- null_ls.builtins.diagnostics.pylint,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.hadolint,
        -- null_ls.builtins.formatting.djhtml,
        -- null_ls.builtins.formatting.djlint,
        null_ls.builtins.hover.printenv,
    },
})

-- null_ls.server_capabilities.documentFormattingProvider = false

-- Setup LSP

vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "gn", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    -- vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}
require("lspconfig")["pyright"].setup({
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
})
require("lspconfig")["tsserver"].setup({
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
})
require("lspconfig")["rust_analyzer"].setup({
    on_attach = on_attach,
    flags = lsp_flags,
    -- Server-specific settings...
    settings = {
        ["rust-analyzer"] = {},
    },
    capabilities = capabilities,
})
require("lspconfig").lua_ls.setup({
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
    capabilities = capabilities,
})

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- setup with some options
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 30,
        mappings = {
            list = {
                { key = "u",     action = "dir_up" },
                { key = "<C-e>", action = "" },
            },
        },
    },
    renderer = {
        group_empty = true,
        highlight_git = false,
    },
    filters = {
        dotfiles = false,
    },
})

-- Noice

require("noice").setup({
    lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
        },
    },
    -- you can enable a preset for easier configuration
    presets = {
        bottom_search = true, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
    },
})

-- Theme

require("nightfox").setup({
    options = {
        -- Compiled file's destination location
        transparent = true,
        terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
        dim_inactive = false, -- Non focused panes set to alternative background
    },
})

require("notify").setup({
    background_colour = "#000000",
    top_down = false,
    render = "compact",
})

vim.cmd("colorscheme nightfox")

-- Sleak line at the bottom.

require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "nightfox",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
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

-- Autocompletition

-- luasnip setup
local luasnip = require("luasnip")

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-u>"] = cmp.mapping.scroll_docs( -4), -- Up
        ["<C-d>"] = cmp.mapping.scroll_docs(4), -- Down
        -- C-b (back) C-f (forward) for snippet placeholder navigation.
        ["<C-q>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable( -1) then
                luasnip.jump( -1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip", option = { show_autosnipets = true } },
    },
})

-- Telescope

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

-- Git

require("gitsigns").setup({
    signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        interval = 1000,
        follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },
    yadm = {
        enable = false,
    },
})

-- Greeter

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
    dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
    dashboard.button("f", "  > Find file", ":cd $HOME/projects | Telescope find_files<CR>"),
    dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
    -- TODO: make wiki command more intelligently. It should be able to use keymap.
    dashboard.button("w", "  > Wiki", ":e ~/vimwiki/index.wiki<CR>"),
    dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
    dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
}

local fortune = require("alpha.fortune")
dashboard.section.footer.val = fortune()

-- Send config to alpha
alpha.setup(dashboard.opts)

-- Disable folding on alpha buffer
vim.cmd([[
    autocmd FileType alpha setlocal nofoldenable
]])

function FormatFunction()
    is_range_formatting = true
    vim.lsp.buf.format({
        async = true,
        range = {
            ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
            ["end"] = vim.api.nvim_buf_get_mark(0, ">"),
        },
    })
end

function ToggleCodespell()
    turn_on_codespell = not turn_on_codespell
end

vim.api.nvim_set_keymap("v", "<leader>ff", ":lua FormatFunction()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>fc", ":lua ToggleCodespell()<CR>", opts)

require("telescope").load_extension("notify")

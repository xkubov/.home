vim.g.mapleader = " "

-- Load plugins
require("plugins")

-- Basic vim settings
vim.opt.autochdir = false
vim.opt.encoding = "utf-8"
vim.opt.mouse = "v"
vim.opt.ruler = true
vim.opt.hlsearch = true
vim.opt.wildmode = "longest,list"
vim.opt.laststatus = 2
vim.opt.relativenumber = false
vim.wo.number = true

local opts = { noremap = true, silent = true }

-- Tab navigation keymaps
vim.api.nvim_set_keymap("n", "<C-w>1", ":tabn 1<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>2", ":tabn 2<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>3", ":tabn 3<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>4", ":tabn 4<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>5", ":tabn 5<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>6", ":tabn 6<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>7", ":tabn 7<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>8", ":tabn 8<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>9", ":tabn 9<CR>", opts)

-- Scrolling keymaps
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", opts)
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", opts)
vim.api.nvim_set_keymap("n", "<C-f>", "<C-f>zz", opts)
vim.api.nvim_set_keymap("n", "<C-b>", "<C-b>zz", opts)

-- Buffer navigation
vim.api.nvim_set_keymap("n", "<backspace>", "<C-^>", opts)

-- Tab management
vim.api.nvim_set_keymap("n", "th", ":tabfirst<CR>", opts)
vim.api.nvim_set_keymap("n", "tl", ":tabnext<CR>", opts)
vim.api.nvim_set_keymap("n", "th", ":tabprev<CR>", opts)
vim.api.nvim_set_keymap("n", "tt", ":tabedit<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-w>c", ":tabedit<CR>", opts)

-- Spell checking
vim.api.nvim_set_keymap("n", "<leader>s", ":set invspell spelllang=sk<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>e", ":set invspell spelllang=en_us<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader><space>", "<Ctrl-space>", opts)

-- File explorer
vim.api.nvim_set_keymap("n", "<C-e>", ":NvimTreeToggle<CR>", opts)

-- VimWiki
vim.api.nvim_set_keymap("n", "<leader><space>", ":VimwikiToggleListItem<CR>", opts)

-- Insert mode keymaps
vim.api.nvim_set_keymap("i", "<C-d>", "<del>", opts)

-- LSP diagnostics keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "gn", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

-- Filetype-specific settings
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

-- Helper function for codespell toggle
local turn_on_codespell = true

function ToggleCodespell()
    turn_on_codespell = not turn_on_codespell
end

vim.api.nvim_set_keymap("n", "<leader>fc", ":lua ToggleCodespell()<CR>", opts)

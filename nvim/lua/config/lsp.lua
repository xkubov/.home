-- LSP Configuration

local M = {}

-- Setup LSP on_attach function
local on_attach = function(_, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

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
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, bufopts)
    
    -- Debug LSP info (add these diagnostic keymaps)
    vim.keymap.set("n", "<leader>li", function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        local info = {}
        table.insert(info, "=== Active LSP Clients ===")
        
        for _, client in ipairs(clients) do
            table.insert(info, "Client: " .. client.name)
            table.insert(info, "  • Definition: " .. tostring(client.server_capabilities.definitionProvider or false))
            table.insert(info, "  • Hover: " .. tostring(client.server_capabilities.hoverProvider or false))
            table.insert(info, "  • References: " .. tostring(client.server_capabilities.referencesProvider or false))
            table.insert(info, "")
        end
        
        -- Show in a buffer instead of printing
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, info)
        vim.bo[buf].buftype = 'nofile'
        vim.bo[buf].bufhidden = 'wipe'
        vim.api.nvim_open_win(buf, true, {
            relative = 'editor',
            width = 50,
            height = #info + 2,
            col = 10,
            row = 5,
            style = 'minimal',
            border = 'rounded',
            title = 'LSP Info'
        })
    end, { desc = "LSP Info", buffer = bufnr })

    vim.keymap.set("n", "<leader>lr", ":LspRestart<CR>", { desc = "Restart LSP", buffer = bufnr })
end

-- Setup LSP capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}

function M.setup()
    -- Configure specific language servers
    require('lspconfig').ruff.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = lsp_flags,
        init_options = {
            settings = {
                -- Enable ruff formatting and linting only
                format = {
                    enabled = true,
                },
                lint = {
                    enabled = true,
                },
            },
        },
    }

    require('lspconfig').pyright.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
            pyright = {
                disableOrganizeImports = true, -- Using Ruff for import organization
            },
            python = {
                analysis = {
                    typeCheckingMode = 'basic', -- Enable Pyright type checking
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    autoImportCompletions = true,
                    diagnosticMode = "workspace",
                    stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
                    reportMissingTypeStubs = false,
                },
            },
        },
    }

    require("lspconfig")["ts_ls"].setup({
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
    })

    require("lspconfig")["rust_analyzer"].setup({
        on_attach = on_attach,
        flags = lsp_flags,
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

    require("lspconfig")["gopls"].setup({
        on_attach = on_attach,
        flags = lsp_flags,
        capabilities = capabilities,
    })

    -- Setup format on save for Python files (using ruff)
    vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.py",
        callback = function()
            vim.lsp.buf.format({ async = false })
        end,
    })

    -- Setup autocompletion
    local luasnip = require("luasnip")
    local cmp = require("cmp")

    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-u>"] = cmp.mapping.scroll_docs(-4), -- Up
            ["<C-d>"] = cmp.mapping.scroll_docs(4),  -- Down
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
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
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
end

return M

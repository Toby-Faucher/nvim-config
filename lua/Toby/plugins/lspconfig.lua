return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev) -- Fixed: Added 'ev' parameter
                local opts = { buffer = ev.buf, silent = true }

                opts.desc = "Show Lsp refs" 
                vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

                opts.desc = "Go to declaration" 
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

                opts.desc = "Show Lsp definitions" 
                vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- Fixed: Added missing <CR>

                opts.desc = "Show Lsp implementations" 
                vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- Fixed: Added missing <CR>

                opts.desc = "Show Lsp type definitions" 
                vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- Fixed: Added missing <CR>

                opts.desc = "See available code actions" 
                vim.keymap.set({ "n", "v" }, "<leader>vca", function() vim.lsp.buf.code_action() end, opts)

                opts.desc = "Smart rename" 
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                opts.desc = "Show buffer diagnostics" 
                vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

                opts.desc = "Show line diagnostics" 
                vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

                opts.desc = "Show docs for what is under cursor" 
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

                opts.desc = "Restart Lsp" 
                vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)

                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            end,
        })

        local signs = {
            [vim.diagnostic.severity.ERROR] = "🐛",
            [vim.diagnostic.severity.WARN] = "🔥",
            [vim.diagnostic.severity.HINT] = "󰠠",
            [vim.diagnostic.severity.INFO] = "", -- Fixed: Changed duplicate WARN to INFO
        }

        vim.diagnostic.config({
            signs = {
                text = signs
            },
            virtual_text = true,
            underline = true,
            update_in_insert = false,
        })

        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")
        local capabilities = cmp_nvim_lsp.default_capabilities() -- Fixed: Changed hyphen to underscore

        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    completion = {
                        callSnippet = "Replace",
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                            [vim.fn.stdpath("config") .. "/lua"] = true,
                        },
                    },
                },
            },
        })

        lspconfig.emmet_ls.setup({
            capabilities = capabilities,
            filetypes = {
                "html",
                "typescriptreact",
                "javascriptreact",
                "less",
                "sass",
                "scss",
                "pug",
                "svelte",
            },
        })

        lspconfig.emmet_language_server.setup({
            capabilities = capabilities,
            filetypes = {
                "css",
                "eruby",
                "html",
                "javascript",
                "javascriptreact",
                "less",
                "sass",
                "scss",
                "pug",
                "typescriptreact",
            },
            init_options = {
                includeLanguages = {},
                excludeLanguages = {},
                extensionsPath = {}, -- Fixed: Corrected spelling
                preferences = {},
                showAbbreviationSuggestions = true,
                showExpandedAbbreviation = "always",
                showSuggestionsAsSnippets = false,
                syntaxProfiles = {},
                variables = {},
            },
        })

        lspconfig.denols.setup({
            capabilities = capabilities,
            root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
        })

        lspconfig.ts_ls.setup({ -- Fixed: Changed 'setuo' to 'setup'
            capabilities = capabilities,
            root_dir = function(fname)
                local util = lspconfig.util
                return not util.root_pattern("deno.json", "deno.jsonc")(fname) -- Fixed: Corrected typo
                    and util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git")(fname)
            end,
            single_file_support = false,
            init_options = {
                preferences = {
                    includeCompletionsWithSnippetText = true,
                    includeCompletionsForImportStatements = true, -- Fixed: Corrected spelling
                },
            },
        })
    end,
}

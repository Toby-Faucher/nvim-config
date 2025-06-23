return {
    "hrsh7th/nvim-cmp",
    -- event = "InsertEnter",
    branch = "main", -- fix for deprecated functions coming in nvim 0.13
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = "make install_jsregexp",
        },
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "nvim-treesitter/nvim-treesitter",
        "onsails/lspkind.nvim",
        "roobert/tailwindcss-colorizer-cmp.nvim",
    },
    config = function()
        local cmp = require("cmp")
        local has_luasnip, luasnip = pcall(require, 'luasnip') 
        local lspkind = require("lspkind")
        local colorizer = require("tailwindcss-colorizer-cmp").formatter

        local rhs = function(keys)
            return vim.api.nvim_replace_termcodes(keys, true, true, true)
        end

        -- Using emoji icons (keeping your style preference)
        local lsp_kinds = {
            Class = '🏛️',
            Color = '🎨',
            Constant = '🔒',
            Constructor = '🏗️',
            Enum = '📋',
            EnumMember = '📄',
            Event = '⚡',
            Field = '🌾',
            File = '📁',
            Folder = '📂',
            Function = '⚙️',
            Interface = '🔌',
            Keyword = '🔑',
            Method = '🔧',
            Module = '📦',
            Operator = '➕',
            Property = '🏷️',
            Reference = '🔗',
            Snippet = '✂️',
            Struct = '🏗️',
            Text = '📝',
            TypeParameter = '🔤',
            Unit = '📏',
            Value = '💎',
            Variable = '📊',
        }
        
        local column = function()
            local _line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col
        end

        -- luasnip custom function
        local in_snippet = function()
            local session = require("luasnip.session")
            local node = session.current_nodes[vim.api.nvim_get_current_buf()]
            if not node then
                return false
            end

            local snippet = node.parent.snippet
            local snip_begin_pos, snip_end_pos = snippet.mark:pos_begin_end() 
            local pos = vim.api.nvim_win_get_cursor(0)
            if pos[1] - 1 >= snip_begin_pos[1] and pos[1] - 1 <= snip_end_pos[1] then
                return true
            end
        end

        -- returns true if the cursor is in the leftmost column or at a whitespace
        local in_whitespace = function()
            local col = column()
            return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')
        end

        local in_leading_indent = function()
            local col = column()
            local line = vim.api.nvim_get_current_line()
            local prefix = line:sub(1, col)
            return prefix:find('^%s*$')
        end

        -- custom shift width
        local shift_width = function()
            if vim.o.softtabstop <= 0 then
                return vim.fn.shiftwidth()
            else
                return vim.o.softtabstop
            end
        end

        -- FIXED: custom smart backspace with proper dedent parameter
        local smart_bs = function(dedent)
            local keys = nil
            if vim.o.expandtab then
                if dedent then
                    keys = rhs('<C-D>')
                else
                    keys = rhs('<BS>')
                end
            else
                local col = column()
                local line = vim.api.nvim_get_current_line()
                local prefix = line:sub(1, col)
                if in_leading_indent() then
                    keys = rhs('<BS>') 
                else
                    -- FIXED: Improved logic from repository version
                    local previous_char = prefix:sub(#prefix, #prefix)
                    if previous_char ~= ' ' then
                        keys = rhs('<BS>')
                    else
                        keys = rhs('<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>')
                    end
                end
            end
            vim.api.nvim_feedkeys(keys, 'nt', true)
        end

        -- custom smart tabs
        local smart_tab = function(opts)
            local keys = nil
            if vim.o.expandtab then
                keys = '<Tab>' -- nvim will insert spaces
            else
                local col = column()
                local line = vim.api.nvim_get_current_line()
                local prefix = line:sub(1, col)
                local in_leading_indent = prefix:find('^%s*$')
                if in_leading_indent then
                    keys = '<Tab>'
                else
                    local sw = shift_width()
                    local previous_char = prefix:sub(#prefix, #prefix)
                    local previous_column = #prefix - #previous_char + 1
                    local current_column = vim.fn.virtcol({ vim.fn.line('.'), previous_column}) + 1
                    local remainder = (current_column - 1) % sw
                    local move = remainder == 0 and sw or sw - remainder
                    keys = (' '):rep(move)
                end
            end
            vim.api.nvim_feedkeys(rhs(keys), 'nt', true)
        end

        local select_next_item = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end

        local select_prev_item = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end

        -- Sophisticated confirmation behavior
        local confirm = function(entry)
            local behavior = cmp.ConfirmBehavior.Replace
            if entry then
                local completion_item = entry.completion_item
                local newText = ''
                if completion_item.textEdit then
                    newText = completion_item.textEdit.newText
                elseif type(completion_item.insertText) == 'string' and completion_item.insertText ~= '' then
                    newText = completion_item.insertText
                else
                    newText = completion_item.word or completion_item.label or ''
                end

                local diff_after = math.max(0, entry.replace_range['end'].character + 1) - entry.context.cursor.col

                if entry.context.cursor_after_line:sub(1, diff_after) ~= newText:sub(-diff_after) then
                    behavior = cmp.ConfirmBehavior.Insert
                end
            end
            cmp.confirm({ select = true, behavior = behavior })
        end
        
        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            experimental = {
                -- IMPROVED: Dynamic ghost text (disabled by default, toggled intelligently)
                ghost_text = false,
            },
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            window = {
                documentation = {
                    border = {'╭', '─', '╮', '│', '╯', '─', '╰', '│'},
                },
                completion = {
                    border = {'┌', '─', '┐', '│', '┘', '─', '└', '│'},
                }
            },  

            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },

            sources = cmp.config.sources({
                { name = "luasnip" },
                { name = "lazydev" }, -- ADDED: For better Lua development
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
                { name = "tailwindcss-colorizer-cmp" },
            }),

            mapping = cmp.mapping.preset.insert({
                ['<BS>'] = cmp.mapping(function(_fallback) smart_bs() end, { 'i', 's'}),

                ["<C-e>"] = cmp.mapping.abort(), -- close completion window
                ['<C-d>'] = cmp.mapping(function()
                    if cmp.visible_docs() then
                        cmp.close_docs()
                    end
                end, { 'i', 's' }),

                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                
                ['<C-j>'] = cmp.mapping(select_next_item),
                ['<C-k>'] = cmp.mapping(select_prev_item),
                ['<C-n>'] = cmp.mapping(select_next_item),
                ['<C-p>'] = cmp.mapping(select_prev_item),
                ['<Down>'] = cmp.mapping(select_next_item),
                ['<Up>'] = cmp.mapping(select_prev_item),

                ['<C-y>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        local entry = cmp.get_selected_entry()
                        confirm(entry)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                ['<CR>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        local entry = cmp.get_selected_entry()
                        confirm(entry)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif has_luasnip and in_snippet() and luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    elseif in_leading_indent() then
                        smart_bs(true) -- FIXED: Pass dedent parameter
                    elseif in_whitespace() then
                        smart_bs()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),

                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        local entries = cmp.get_entries()
                        if #entries == 1 then
                            confirm(entries[1])
                        else
                            cmp.select_next_item()
                        end
                    elseif has_luasnip and luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    elseif in_whitespace() then
                        smart_tab()
                    else
                        cmp.complete()
                    end
                end, { 'i', 's' }),
            }), -- FIXED: Added missing comma
            formatting = {
                format = function(entry, vim_item)
                    vim_item.kind = string.format('%s %s', lsp_kinds[vim_item.kind] or '', vim_item.kind)

                    vim_item.menu = ({
                        buffer = "[Buffer]",
                        nvim_lsp = "[LSP]",
                        luasnip = "[LuaSnip]",
                        nvim_lua = "[Lua]",
                        latex_symbols = "[LaTeX]",
                        lazydev = "[LazyDev]", -- ADDED: Menu label for lazydev
                    })[entry.source.name]

                    -- FIXED: Corrected function name
                    vim_item = lspkind.cmp_format({
                        maxwidth = 30,
                        ellipsis_char = "...",
                    })(entry, vim_item)

                    if entry.source.name == "nvim_lsp" then
                        vim_item = colorizer(entry, vim_item)
                    end

                    return vim_item
                end
            }
        })

        -- IMPROVED: Smart ghost text toggle
        local config = require('cmp.config')
        local toggle_ghost_text = function()
            if vim.api.nvim_get_mode().mode ~= 'i' then
                return
            end

            -- FIXED: Use proper cursor column function
            local cursor_column = vim.fn.col('.')
            local current_line_contents = vim.fn.getline('.')
            local character_after_cursor = current_line_contents:sub(cursor_column, cursor_column)

            -- Only show ghost text at word boundaries, not inside keywords
            local should_enable_ghost_text = character_after_cursor == '' or vim.fn.match(character_after_cursor, [[\k]]) == -1

            local current = config.get().experimental.ghost_text
            if current ~= should_enable_ghost_text then
                config.set_global({
                    experimental = {
                        ghost_text = should_enable_ghost_text,
                    },
                })
            end
        end

        vim.api.nvim_create_autocmd({ 'InsertEnter', 'CursorMovedI' }, {
            callback = toggle_ghost_text,
        })
    end
}

return {
    -- Mini nvim
    { "echasnovski/mini.nvim", version = false },
    -- Comments
    {
        'echasnovski/mini.comment',
        version = false,
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            require('ts_context_commentstring').setup {
                enable_autocmd = false,
            }
            require("mini.comment").setup {
                options = {
                    custom_commentstring = function()
                        return require('ts_context_commentstring.internal').calculate_commentstring({
                            key = 'commentstring'
                        }) or vim.bo.commentstring
                    end,
                },
            }
        end
    },
    -- File Explorer (that works with oil)
    {
        'echasnovski/mini.files',
        config = function()
            local MiniFiles = require("mini.files")
            MiniFiles.setup({
                mappings = {
                    go_in = "<CR>",
                    go_in_plus = "L",
                    go_out = "-",
                    go_out_plus = "H",
                },
            })
            vim.keymap.set("n", "<leader>ee", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer"})
            vim.keymap.set("n", "<leader>ef", function()
                MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
                MiniFiles.reveal_cwd()
            end, { desc = "Toggle into currently opened file"} )
        end
    },
    {
        'echasnovski/mini.surround',
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            custom_surroundings = nil,
            
            highlight_duration = 300,
            
            mappings = {
                add = 'sa',            -- Add surrounding in Normal and Visual modes
                delete = 'ds',         -- Delete surrounding
                find = 'sf',           -- Find surrounding (to the right)
                find_left = 'sF',      -- Find surrounding (to the left)
                highlight = 'sh',      -- Highlight surrounding
                replace = 'sr',        -- Replace surrounding
                update_n_lines = 'sn', -- Update `n_lines`

                suffix_last = 'l',     -- Suffix to search with "prev" method
                suffix_next = 'n',     -- Suffix to search with "next" method
            },
            n_lines = 20,
            
            respect_selection_type = false,

            search_method = 'cover',
            
            silent = false,
        },
    },
    {
        'echasnovski/mini.trailspace',
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            local miniTrailspace = require("mini.trailspace")
            
            miniTrailspace.setup({
                only_in_normal_buffers = true,        
            })

            vim.keymap.set("n", "<leader>cw", function() miniTrailspace.trim() end, { desc = "Erase Whitespace" } )
            
            vim.api.nvim_create_autocmd("CursorMoved", {
                pattern = "*",
                callback = function()
                    require("mini.trailspace").unhighlight()
                end,
            })
        end
    },
    {
        'echasnovski/mini.splitjoin',
        config = function()
            local miniSplitjoin = require("mini.splitjoin")
            
            miniSplitjoin.setup({
                mappings = { toggle = "" },
            }) 
 
            vim.keymap.set( { "n", "x" }, "sj", function() miniSplitJoin.join() end, { desc = "Join arguments" })
            vim.keymap.set( { "n", "x" }, "sk", function() miniSplitJoin.split() end, { desc = "Split arguments" })
        end
    }
}

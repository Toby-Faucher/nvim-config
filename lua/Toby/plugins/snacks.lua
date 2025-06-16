return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            quickfile = {
                enabled = true,
                exclude = {"latex"}
            },

            picker = { 
                enabled = true,
                matchers = {
                    frecency = true,
                    cwd_bonus = true,
                },
                formatters = {
                    file = {
                        filename_first = false,
                        filename_only = false,
                        icon_width = 2,
                    },
                },
                layout = {
                    preset = "telescope",
                    cycle = false,
                },
                layouts = {
                    select = {
                        preview = false,
                        layout = {
                            backdrop = false,
                            width = 0.6,
                            min_width = 80,
                            height = 0.4,
                            min_height = 10,
                            box = "vertical",
                            border = "rounded",
                            title = "{title}",
                            title_pos = "center",
                            { win = "input", height = 1, border = "bottom" },
                            { win = "list",  border = "none" },
                            { win = "preview", title = "{preview}", width = 0.6, height = 0.4,  border = "top" },
                        },
                    },
                    telescope = {
                        reverse = true,
                        layout = {
                            box = "horizontal",
                            backdrop = false,
                            width = 0.8,
                            height = 0.9,
                            border = "none",
                            {
                                box = "vertical",
                                { win = "list", title = " Results ", title_pos = "center",  border = "rounded" },
                                { win = "input", height = 1, border = "rounded", title = "{title}{live}{flags}", title_pos = "center" },
                            },
                            {
                                win = "preview",
                                title = "{preview:Preview}",
                                width = 0.50,
                                border = "rounded",
                                title_pos = "center",
                            },
                        },
                    },
                    ivy = {
                        layout = {
                            box = "vertical",
                            backdrop = false,
                            width = 0,
                            height = 0.4,
                            border = "none",
                            title = "{title},{live},{flags}",
                            title_pos = "left",
                            {
                                box = "horizontal",
                                { win = "list", border = "none" },
                                { win = "preview", title = "{preview}", width = 0.5, border = "left" },
                            },
                        },
                    },
                }
            }, 
        },
        dashaboard = {
            enabled = true,
            sections = {
                {section = "header" },
                {section = "keys", gap = 1, padding = 1 },
                {section = "startup" },
            },
        },
        
        keys = {
            {"<leader>lg", function() require("snacks").lazygit() end, desc = "lazygit"},            
            {"<leader>gl", function() require("snacks").lazygit.log() end, desc = "lazygit logs"},            
            {"<leader>rn", function() require("snacks").rename.rename_file() end, desc = "fast rename current files"},            
            {"<leader>db", function() require("snacks").bufdelete() end, desc = "delete or close buffer"},            

            -- Snacks Picker
            {"<leader>pf", function() require("snacks").picker.files() end, desc = "Finds Files using the snacks picker"},            
            {"<leader>pc", function() require("snacks").picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Finds Config File"},            
            {"<leader>ps", function() require("snacks").picker.grep() end, desc = "Grep word"},            
            {"<leader>pws", function() require("snacks").picker.grep_word() end, desc = "Seach visual selction or Word", mode = { "n", "x",}},            
            {"<leader>pk", function() require("snacks").picker.keymaps({ layout = "ivy"}) end, desc = "Seach Keymaps with the snack picker", mode = { "n", "x",}},            
            
            -- Git Stuff
            {"<leader>gbr", function() require("snacks").picker.git_branches({ layout = "select"}) end, desc = "Pick and Switch Git Branches"},            
            
            -- Other Utils
            {"<leader>th", function() require("snacks").picker.colorschemes({ layout = "ivy"}) end, desc = "Pick colorschemes"},            
            {"<leader>vh", function() require("snacks").picker.help() end, desc = "Help pages"},            
        }
    },
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPre", "BufNewFile"},
        keys = {
            {"<leader>pt", function() require("snacks").picker.todo_comments() end, desc = "Todo"},            
            {"<leader>pT", function() require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" }}) end, desc = "Todo/Fix/Fixme"},            
        }
    }
}

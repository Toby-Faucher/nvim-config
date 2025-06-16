return {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile"},
    dependencies = { "nvim-lua/plenary.nvim"},
    config = function()
        local todo_comments = require("todo-comments")

        todo_comments.setup({
            keywords = {
                FIX = {
                    icon = "🐛", -- icon used for the sign, also in searches
                    color = "error", -- named color
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE"} -- alternitives
                },
                TODO = {
                    icon = "✔️", 
                    color = "warning", 
                },
                HACK = {
                    icon = "🔥", 
                    color = "warning",
                    alt = { "DON'T SKIP" }
                },
                WARN = {
                    icon = "⚠️", 
                    color = "warning",
                    alt = { "WARNING", "XXX" }
                },
                PERF = {
                    icon = "🕚", 
                    alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" }
                },
                NOTE = {
                    icon = "ℹ️", 
                    color = "hint",
                    alt = { "INFO", "READ", "COLORS" }
                },
                TEST = {
                    icon = "🧪", 
                    color = "test",
                    alt = { "TESTING", "PASSED", "FAILED" }
                },
            }
        })

        -- Keymaps
        vim.keymap.set("n", "]t", function()
            todo_comments.jump_next()
        end, {desc = "Jump to the next comment"})

        vim.keymap.set("n", "[t", function()
            todo_comments.jump_prev()
        end, {desc = "Jump to the previous comment"})
    end
}

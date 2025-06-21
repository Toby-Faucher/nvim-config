return {
    {
		"tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gg", vim.cmd.Git)

            local myFugitive = vim.api.nvim_create_augroup("myFugitive", {})

            local autocmd = vim.api.nvim_create_autocmd
            autocmd("BufWinEnter", {
                group = myFugitive,
                pattern = "*",
                callback = function()
                    if vim.bo.ft ~= "fugitive" then
                        return
                    end

                    local bufnr = vim.api.nvim_get_current_buf()
                    local opts = {buffer = bufnr, remap = false}

                    vim.keymap.set("n", "<leader>P", function()
                        vim.cmd.Git('push')
                    end, opts)

                    -- NOTE: rebase always
                    vim.keymap.set("n", "<leader>p", function()
                        vim.cmd.Git({'pull',  '--rebase'})
                    end, opts)

                    -- NOTE: easy set up branch that wasn't setup properly
                    vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
                end,
            })
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                end

                -- Actions
                map("n", "<leader>gs", gs.stage_hunk, "Stage Hunk")
                map("n", "<leader>gr", gs.reset_hunk, "Reset Hunk")
                map("n", "<leader>gs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Stage Hunk")
                map("n", "<leader>gr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "Reset Hunk")
                map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
                map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")

                map("n", "<leader>gu", gs.undo_stage_hunk, "Undo Stage Hunk")
                map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")

                map("n", "<leader>gbl", function() gs.blame_line( { full = true } )  end, "Blame line")
                map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle line blame")

                map("n", "<leader>gd", gs.diffthis, "Diff this")
                map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff this ~")

                map("n", "]h", gs.next_hunk, "Next hunk")
                map("n", "[h", gs.prev_hunk, "Prev hunk")
                
                -- Nav
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
            end

        }
    }
}

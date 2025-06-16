return {
    "stevearc/oil.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        require("oil").setup({
            default_file_explorer = true, -- this changes the default file explorer
            columns = { },
            keymaps = {
                ["<M-h>"] = "actions.select_split",
                ["q"] = "actions.close",
            },
            delete_to_trash = true,
            view_options = {
                show_hidden = true,
            },
            skip_confirm_for_simple_edits = true,
        })  

        --keymaps for oil
        -- opens parent dir over the current active window
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent dir"})
        -- opens parent dir in a float window
        vim.keymap.set("n", "<leader>-", require("oil").toggle_float)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "oil",
            callback = function()
                vim.opt_local.cursorline = true
            end,
        })
    end,
}

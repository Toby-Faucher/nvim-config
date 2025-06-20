return {
    "rmagatti/auto-session",
    config = function()
        local auto_session = require("auto-session")

        auto_session.setup({
            auto_restore_enabled = false,
            auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/"}, 
        })

        vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restores session for cwd"})
        vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for root dir"})
    end,
}

return {
    "ThePrimeagen/git-worktree.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        local gitworktree = require("git-worktree")

        gitworktree.setup()

        
        require("telescope").load_extension("git_worktree")

        -- create new worktree
        vim.keymap.set("n", "<leader>wl", function()
            require("telescope").extensions.git_worktree.git_worktrees()
        end, { desc = "list git worktree" } )

        vim.keymap.set("n", "<leader>wc", function()
            require("telescope").extensions.git_worktree.create_git_worktrees()
        end, { desc = "create git worktree" } )
    end

}

return {
    -- Existing tailwindcss-colorizer-cmp.nvim plugin
    "roobert/tailwindcss-colorizer-cmp.nvim",

    -- Existing nvim-colorizer.lua plugin
    {
        "NvChad/nvim-colorizer.lua",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        opts = {},
        config = function()
            local nvchadcolorizer = require("colorizer")
            local tailwindcolorizer = require("tailwindcss-colorizer-cmp")

            nvchadcolorizer.setup({
                user_default_options = {
                    tailwind = true,
                },
                filetypes = { "html", "css", "javascript", "typescript", "jsx", "tsx", "vue", "svelte" },
            })

            tailwindcolorizer.setup({
                color_square_width = 2,
            })

            -- Autocmd to attach colorizer to buffers
            vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
                callback = function()
                    vim.cmd("ColorizerAttachToBuffer")
                end,
            })
        end,
    },

    -- NEW: Add tailwind-tools.nvim plugin
    {
        "luckasRanarison/tailwind-tools.nvim",
        -- It's good practice to specify dependencies if they are known,
        -- e.g., on nvim-lspconfig if it's not already globally loaded.
        dependencies = { "neovim/nvim-lspconfig" },
        -- Optional: Configure tailwind-tools.nvim here.
        -- For a basic setup, opts can be empty, but you can add settings
        -- based on the plugin's documentation later (e.g., for formatting options).
        opts = {},
        -- If you want to perform actions after setup, you can use a config function
        -- config = function()
        --   require("tailwind-tools").setup({
        --      -- Your custom settings for tailwind-tools.nvim
        --      -- e.g., formatter = "prettierd",
        --   })
        -- end,
    },
}

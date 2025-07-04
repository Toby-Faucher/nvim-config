return {
    {
        "b0o/incline.nvim",
        enabled = true,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local devicons = require("nvim-web-devicons")
            local incline = require("incline")

            incline.setup({
                hide = {
                    only_win = false,
                },

                render = function(props)
                    local bufname = vim.api.nvim_buf_get_name(props.buf)
                    local filename = vim.fn.fnamemodify(bufname, ":t")
                    if filename == '' then filename = '[No Name]' end

                    local ext = vim.fn.fnamemodify(bufname, ":e")
                    local icon, icon_color = devicons.get_icon(filename, ext, { default = true} )

                    local modified = vim.bo[props.buf].modified

                    return {
                        { " ", icon, " ", guifg = iconcolor },
                        { filename, gui = modifed and "bold" or "none" },
                        modified and { "[+],", guifg = "#ff9e64" } or "",
                        " ",
                    }
                end
            })
        end
    }
}

return {
  "S1M0N38/love2d.nvim",
  ft = "lua", -- load only for Lua files
  config = function()
    require("love2d").setup({
      -- You can optionally configure things here
    })
  end,
}

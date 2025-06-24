local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in the visual selection"})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in the visual selection"})

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered"})
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move down in buffer with cursor centered"})


vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- Clipboard
-- Past without replacing clipboard content
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("v", "p", '"_dP', opts)

vim.keymap.set({ "n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>") 

vim.keymap.set("n", "<C-c>", ":nohl<CR>", {desc = "Clear search hl", silent = true}) 

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format) 
vim.keymap.set("n", "Q", "<nop>") 
vim.keymap.set("n", "x", '"_x', opts) -- prevents deleted chars from copying to clipboard

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word cursor is on globally"}) 
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true,  desc = "makes file executable"}) 

-- Highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true}),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- tab stuff
vim.keymap.set("n", "<leader>to", "<cmd>tabnew<CR>")   -- open new tab
vim.keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>") -- close current tab
vim.keymap.set("n", "<leader>tn", "<cmd>tabn<CR>")     -- go to next tab
vim.keymap.set("n", "<leader>tp", "<cmd>tabp<CR>")     -- go to previous tab
vim.keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>") -- go to current tab in new tab


-- split 
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically"}) -- Splits verticaly
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally"}) -- Splits horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size"}) -- Makes split windows equaly width and height
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split"}) -- Closes the current split window

-- copy filepath to clipboard
vim.keymap.set("n", "<leader>fp", function()
    local filePath = vim.fn.expand("%:~") -- Gets the file path relitive to the home dir
    vim.fn.setreg("+", filePath)          -- Copy the file path to the clipboard reg
    print("Filepath copied to clipboard: " .. filePath)
end, { desc = "Copy file path to clipboard"})

-- Run py file
vim.api.nvim_create_user_command("RunPySolution", function()
  vim.cmd("w")  -- Save buffer
  local file = vim.fn.expand("%:p")
  vim.cmd("botright split | resize 15 | terminal python3 " .. file)
end, {})
vim.keymap.set("n", "<leader>rp", ":RunPySolution<CR>", { desc = "Run Python file (LeetCode-style)" })

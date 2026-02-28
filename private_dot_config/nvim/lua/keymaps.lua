-- Clipboard
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>Y", 'mzggVG"+y`z', { desc = "Copy file to clipboard" })

-- Centered scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Move lines in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Paste without losing register
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })

-- Delete to void register
vim.keymap.set("n", "<leader>x", '"_d', { desc = "Delete to void" })
vim.keymap.set("v", "<leader>x", '"_d', { desc = "Delete to void" })

-- Quick save
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })

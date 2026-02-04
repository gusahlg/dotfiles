vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy's to clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy's to clipboard" })
vim.keymap.set("n", "Å", ':!ls', { desc = "fun lil command" })

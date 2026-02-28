return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({})
    pcall(telescope.load_extension, "fzf")

    vim.keymap.set("n", "<leader>f",  ":Telescope find_files<CR>",  { desc = "Find files" })
    vim.keymap.set("n", "<leader>sg", ":Telescope live_grep<CR>",   { desc = "Search grep" })
    vim.keymap.set("n", "<leader>sb", ":Telescope buffers<CR>",     { desc = "Search buffers" })
    vim.keymap.set("n", "<leader>sd", ":Telescope diagnostics<CR>", { desc = "Search diagnostics" })
    vim.keymap.set("n", "<leader>sh", ":Telescope help_tags<CR>",   { desc = "Search help" })
    vim.keymap.set("n", "<leader>sw", ":Telescope grep_string<CR>", { desc = "Search word under cursor" })
  end,
}

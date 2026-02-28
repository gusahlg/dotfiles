return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local opts = { buffer = bufnr }

        vim.keymap.set("n", "]c", function() gs.nav_hunk("next") end, opts)
        vim.keymap.set("n", "[c", function() gs.nav_hunk("prev") end, opts)
        vim.keymap.set("n", "<leader>gb", gs.blame_line, opts)
      end,
    })
  end,
}

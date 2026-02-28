return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "rust", "lua", "vim", "query", "c", "cpp" },
      highlight = { enable = true, additional_vim_regex_highlighting = false },
    })
  end,
}

local is_nixos = vim.fn.filereadable "/etc/NIXOS" == 1
local can_install_parsers = (not is_nixos) or vim.fn.executable "tree-sitter" == 1

-- Remove nvim-treesitter parsers that shadow neovim's bundled parsers.
-- Neovim ships its own runtime queries (e.g. lua/highlights.scm) that expect
-- the grammar version bundled with neovim. If nvim-treesitter has an older
-- compiled .so for the same language, it shadows the bundled one and the
-- query parser hits "Invalid field name ..." errors (e.g. inside snacks
-- pickers). Drop the duplicates so neovim's own parser wins.
do
  local ts_parser_dir = vim.fn.stdpath "data" .. "/lazy/nvim-treesitter/parser"
  if vim.fn.isdirectory(ts_parser_dir) == 1 then
    local bundled = { "c", "lua", "markdown", "markdown_inline", "query", "vim", "vimdoc" }
    for _, lang in ipairs(bundled) do
      local f = ts_parser_dir .. "/" .. lang .. ".so"
      if vim.fn.filereadable(f) == 1 then vim.fn.delete(f) end
    end
  end
end

local parsers = {
  "bash",
  "c",
  "cmake",
  "comment",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "git_config",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "hcl",
  "html",
  "ini",
  "java",
  "javascript",
  "json",
  "jsonc",
  "kotlin",
  "lua",
  "luadoc",
  "make",
  "markdown",
  "markdown_inline",
  "nix",
  "php",
  "python",
  "query",
  "regex",
  "ruby",
  "rust",
  "scss",
  "sql",
  "svelte",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "vue",
  "xml",
  "yaml",
  "zig",
}

return {
  {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      opts.treesitter = opts.treesitter or {}
      opts.treesitter.highlight = true
      opts.treesitter.indent = true
      opts.treesitter.auto_install = can_install_parsers
      opts.treesitter.ensure_installed = can_install_parsers and parsers or {}
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      if vim.fn.executable "tree-sitter" == 1 then
        vim.cmd.TSUpdate()
      else
        vim.notify("Skipping TSUpdate: install tree-sitter through Nix or run `nix develop ~/.config/nvim` first")
      end
    end,
  },
}

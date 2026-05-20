local is_nixos = vim.fn.filereadable "/etc/NIXOS" == 1

local mason_lsp_servers = {
  "lua_ls",
  "nixd",
  "rust_analyzer",
  "clangd",
  "pyright",
  "ts_ls",
  "eslint",
  "bashls",
  "jsonls",
  "yamlls",
  "taplo",
  "marksman",
  "dockerls",
  "docker_compose_language_service",
  "html",
  "cssls",
  "gopls",
  "terraformls",
  "zls",
}

local mason_tools = {
  "lua-language-server",
  "nixd",
  "rust-analyzer",
  "clangd",
  "pyright",
  "typescript-language-server",
  "eslint-lsp",
  "bash-language-server",
  "json-lsp",
  "yaml-language-server",
  "taplo",
  "marksman",
  "dockerfile-language-server",
  "docker-compose-language-service",
  "html-lsp",
  "css-lsp",
  "gopls",
  "terraform-ls",
  "zls",
  "tree-sitter-cli",
}

return {
  {
    "mason-org/mason.nvim",
    opts = {
      PATH = is_nixos and "skip" or "prepend",
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.automatic_enable = not is_nixos
      opts.ensure_installed = is_nixos and {} or mason_lsp_servers
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = is_nixos and {} or mason_tools
    end,
  },
}

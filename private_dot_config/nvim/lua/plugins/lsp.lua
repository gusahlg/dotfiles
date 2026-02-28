return {
  "neovim/nvim-lspconfig",
  config = function()
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
      end,
    })

    -- LSP toggle
    local function analyzer_toggle()
      local stopped = false
      for _, client in ipairs(vim.lsp.get_clients()) do
        if client.name == "rust_analyzer" or client.name == "clangd" then
          client.stop()
          stopped = true
        end
      end
      if stopped then
        print("rust-analyzer + clangd OFF")
      else
        vim.cmd("LspStart rust_analyzer")
        vim.cmd("LspStart clangd")
        print("rust-analyzer + clangd ON")
      end
    end

    vim.keymap.set("n", "<leader>lq", analyzer_toggle, { desc = "Toggle rust-analyzer + clangd" })

    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          diagnostics = { enable = false },
          procMacro = { enable = false },
          lens = { enable = false },
        },
      },
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
        },
      },
    })

    vim.lsp.config("clangd", {})

    vim.lsp.enable({ "rust_analyzer", "lua_ls", "clangd" })
  end,
}

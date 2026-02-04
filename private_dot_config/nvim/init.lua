-- =========================
-- init.lua (Neovim 0.11+ LSP, no completion, no autoformat)
-- =========================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.termguicolors = true

vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>Y", 'mzggVG"+y`z', { desc = "Copy file to clipboard" })

-- Lsp control
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

vim.keymap.set("n", "<leader>lq", analyzer_toggle, { desc = "ON/OFF toggle rust-analyzer + clangd" })

-- =========================
-- lazy.nvim bootstrap
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- Plugins
-- =========================
require("lazy").setup({
  -- Theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "rust", "lua", "vim", "query", "c", "cpp" },
        highlight = { enable = true, additional_vim_regex_highlighting = false },
      })
    end,
  },

  -- Telescope (+ fzf)
  {
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

      vim.keymap.set("n", "<leader>f", ':Telescope find_files<CR>', { desc = "Findfiles with telescope" })
    end,
  },
    -- Harpoon (fast file jumping)
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      local function item_path(item)
        if type(item) == "string" then return item end
        if type(item) == "table" then
          return item.value or item[1]
        end
        return nil
      end

      local function norm(p)
        if not p or p == "" then return "" end
        return vim.fn.fnamemodify(p, ":p")
      end

      local function compact_and_save(list)
        local new_items = {}
        for _, item in ipairs(list.items or {}) do
          local p = item_path(item)
          if p and p ~= "" then
            table.insert(new_items, item)
          end
        end
        list.items = new_items
        pcall(function() list:save() end)
        pcall(function() list:sync() end)
      end

      local function remove_current_file_no_gaps()
        local list = harpoon:list()
        local cur = norm(vim.api.nvim_buf_get_name(0))
        local new_items = {}

        for _, item in ipairs(list.items or {}) do
          local p = norm(item_path(item))
          -- keep everything except the current file (also drops blanks)
          if p ~= "" and p ~= cur then
            table.insert(new_items, item)
          end
        end

        list.items = new_items
        pcall(function() list:save() end)
        pcall(function() list:sync() end)
      end

      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
        compact_and_save(harpoon:list())
      end, { desc = "Harpoon: add file" })

      vim.keymap.set("n", "<leader>d", function()
        remove_current_file_no_gaps()
      end, { desc = "Harpoon: remove current file (no gaps)" })

      vim.keymap.set("n", "<leader>c", function()
        require("harpoon"):list():clear()
      end, { desc = "Harpoon: clear all files" })


      vim.keymap.set("n", "<leader>h", function()
        compact_and_save(harpoon:list())
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon: menu" })

      vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon: file 1" })
      vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon: file 2" })
      vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon: file 3" })
      vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon: file 4" })
      vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { desc = "Harpoon: file 5" })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- LSP keymaps when a server attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
          vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)
        end,
      })

      -- ===== rust-analyzer (panic workaround) =====
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            diagnostics = { enable = false },
            procMacro = { enable = false },

            lens = { enable = false },
          },
        },
      })

      -- ===== lua-language-server =====
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- ===== clangd (C/C++ stdlib navigation) =====
      vim.lsp.config("clangd", {})

      -- Enable servers
      vim.lsp.enable({ "rust_analyzer", "lua_ls", "clangd" })
    end,
  },
})


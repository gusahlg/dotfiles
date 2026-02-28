return {
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
    end, { desc = "Harpoon: remove current file" })

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
}

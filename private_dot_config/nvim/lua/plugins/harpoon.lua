local function item_path(item)
  if type(item) == "string" then return item end
  if type(item) == "table" then return item.value or item[1] end
  return nil
end

local function normalize(path)
  if not path or path == "" then return "" end
  return vim.fn.fnamemodify(path, ":p")
end

local function compact_and_save(list)
  local new_items = {}
  for _, item in ipairs(list.items or {}) do
    local path = item_path(item)
    if path and path ~= "" then table.insert(new_items, item) end
  end

  list.items = new_items
  pcall(function() list:save() end)
  pcall(function() list:sync() end)
end

local function remove_current_file(list)
  local current = normalize(vim.api.nvim_buf_get_name(0))
  local new_items = {}

  for _, item in ipairs(list.items or {}) do
    local path = normalize(item_path(item))
    if path ~= "" and path ~= current then table.insert(new_items, item) end
  end

  list.items = new_items
  pcall(function() list:save() end)
  pcall(function() list:sync() end)
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local harpoon = require "harpoon"
    harpoon:setup()

    local function list()
      return harpoon:list()
    end

    vim.keymap.set("n", "<leader>ha", function()
      list():add()
      compact_and_save(list())
    end, { desc = "Harpoon add file" })

    vim.keymap.set("n", "<leader>hd", function()
      remove_current_file(list())
    end, { desc = "Harpoon remove current file" })

    vim.keymap.set("n", "<leader>hc", function()
      list():clear()
    end, { desc = "Harpoon clear files" })

    vim.keymap.set("n", "<leader>hh", function()
      compact_and_save(list())
      harpoon.ui:toggle_quick_menu(list())
    end, { desc = "Harpoon menu" })

    for index = 1, 5 do
      vim.keymap.set("n", ("<leader>%d"):format(index), function()
        list():select(index)
      end, { desc = ("Harpoon file %d"):format(index) })
    end
  end,
}

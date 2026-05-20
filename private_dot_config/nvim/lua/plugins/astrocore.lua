local function snacks_picker(name, opts)
	return function()
		local snacks = rawget(_G, "Snacks")
		if not snacks then
			local ok, loaded = pcall(require, "snacks")
			if ok then
				snacks = loaded
			end
		end

		if snacks and snacks.picker and snacks.picker[name] then
			snacks.picker[name](opts or {})
		else
			vim.notify(("snacks.nvim picker '%s' is not available"):format(name), vim.log.levels.WARN)
		end
	end
end

local toggles = require("user.toggles")

return {
	"AstroNvim/astrocore",
	opts = {
		features = {
			autopairs = true,
			cmp = true,
			diagnostics = {
				virtual_text = true,
				virtual_lines = true,
			},
			highlighturl = true,
			notifications = true,
		},
		diagnostics = {
			virtual_text = {
				spacing = 2,
				source = "if_many",
				prefix = function(diagnostic)
					local icons = {
						[vim.diagnostic.severity.ERROR] = "E",
						[vim.diagnostic.severity.WARN] = "W",
						[vim.diagnostic.severity.INFO] = "I",
						[vim.diagnostic.severity.HINT] = "H",
					}
					return icons[diagnostic.severity] or ">"
				end,
			},
			virtual_lines = {
				current_line = true,
			},
			float = {
				border = "rounded",
				source = "if_many",
				focusable = false,
			},
			update_in_insert = false,
			underline = true,
			severity_sort = true,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "E",
					[vim.diagnostic.severity.WARN] = "W",
					[vim.diagnostic.severity.INFO] = "I",
					[vim.diagnostic.severity.HINT] = "H",
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticError",
					[vim.diagnostic.severity.WARN] = "DiagnosticWarn",
					[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
					[vim.diagnostic.severity.HINT] = "DiagnosticHint",
				},
			},
		},
		options = {
			opt = {
				number = true,
				relativenumber = true,
				expandtab = true,
				shiftwidth = 4,
				tabstop = 4,
				smartindent = true,
				termguicolors = true,
				signcolumn = "yes",
				cursorline = true,
				wrap = false,
				scrolloff = 8,
				sidescrolloff = 8,
				splitbelow = true,
				splitright = true,
				updatetime = 250,
				clipboard = "unnamedplus",
			},
		},
		mappings = {
			n = {
				["<leader>y"] = { '"+y', desc = "Copy to clipboard" },
				["<leader>Y"] = { 'mzggVG"+y`z', desc = "Copy file to clipboard" },
				["<leader>w"] = { "<cmd>w<cr>", desc = "Save file" },
				["<leader>f"] = { snacks_picker("files"), desc = "Find files" },
				["<leader>sg"] = { snacks_picker("grep"), desc = "Search grep" },
				["<leader>sb"] = { snacks_picker("buffers"), desc = "Search buffers" },
				["<leader>sd"] = { snacks_picker("diagnostics"), desc = "Search diagnostics" },
				["<leader>sh"] = { snacks_picker("help"), desc = "Search help" },
				["<leader>sw"] = { snacks_picker("grep_word"), desc = "Search word under cursor" },
				["<leader>uc"] = { toggles.toggle_buffer_completion, desc = "Toggle code suggestions (buffer)" },
				["<leader>uC"] = { toggles.toggle_global_completion, desc = "Toggle code suggestions (global)" },
				["<leader>ud"] = { toggles.toggle_diagnostics, desc = "Toggle error detection" },
				["<C-d>"] = { "<C-d>zz", desc = "Half page down" },
				["<C-u>"] = { "<C-u>zz", desc = "Half page up" },
				n = { "nzzzv", desc = "Next search result" },
				N = { "Nzzzv", desc = "Previous search result" },
			},
			v = {
				["<leader>y"] = { '"+y', desc = "Copy to clipboard" },
				J = { ":m '>+1<cr>gv=gv", desc = "Move selection down" },
				K = { ":m '<-2<cr>gv=gv", desc = "Move selection up" },
			},
			x = {
				["<leader>p"] = { '"_dP', desc = "Paste without yanking" },
				["<leader>x"] = { '"_d', desc = "Delete to void" },
				["<leader>sw"] = { snacks_picker("grep_word"), desc = "Search selection" },
			},
		},
		autocmds = {
			diagnostic_float = {
				{
					event = "CursorHold",
					desc = "Show diagnostics at cursor",
					callback = function()
						toggles.show_cursor_diagnostics()
					end,
				},
			},
		},
	},
}

-- Last-mile user configuration runs after plugins are set up.

vim.filetype.add({
	extension = {
		env = "sh",
		tfvars = "terraform",
	},
	filename = {
		[".env"] = "sh",
		["flake.lock"] = "json",
	},
})

local toggles = require("user.toggles")

vim.keymap.set("n", "<leader>uc", toggles.toggle_buffer_completion, { desc = "Toggle code suggestions (buffer)" })
vim.keymap.set("n", "<leader>uC", toggles.toggle_global_completion, { desc = "Toggle code suggestions (global)" })
vim.keymap.set("n", "<leader>ud", toggles.toggle_diagnostics, { desc = "Toggle error detection" })

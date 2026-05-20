return {
	"saghen/blink.cmp",
	opts = {
		enabled = function()
			-- Respect the buffer/global completion toggles in lua/user/toggles.lua.
			-- Buffer flag wins when set; otherwise fall back to the AstroCore feature flag.
			if vim.b.completion == false then return false end
			if vim.b.completion == nil then
				local ok, astrocore = pcall(require, "astrocore")
				if ok and astrocore.config and astrocore.config.features then
					if astrocore.config.features.cmp == false then return false end
				end
			end
			return true
		end,
		keymap = {
			preset = "default",
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = { "select_and_accept", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
		},
		completion = {
			list = {
				selection = {
					preselect = true,
					auto_insert = false,
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 300,
			},
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
			},
			ghost_text = {
				enabled = true,
			},
			menu = {
				auto_show = true,
			},
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		signature = {
			enabled = true,
		},
	},
}

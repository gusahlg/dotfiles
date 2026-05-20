return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "night",
			terminal_colors = true,
			styles = {
				comments = { italic = false },
				keywords = { italic = false },
			},
			on_highlights = function(highlights, colors)
				local util = require("tokyonight.util")
				local rust_highlights = {
					["@comment.rust"] = { fg = colors.dark5, italic = false },
					["@keyword.rust"] = { fg = colors.magenta, bold = true },
					["@keyword.function.rust"] = { fg = colors.magenta, bold = true },
					["@keyword.storage.rust"] = { fg = colors.cyan },
					["@keyword.return.rust"] = { fg = colors.magenta, bold = true },
					["@function.rust"] = { fg = colors.blue },
					["@function.call.rust"] = { fg = colors.blue },
					["@function.method.rust"] = { fg = colors.blue },
					["@function.method.call.rust"] = { fg = colors.blue },
					["@function.macro.rust"] = { fg = colors.teal },
					["@constructor.rust"] = { fg = colors.yellow },
					["@type.rust"] = { fg = colors.blue1 },
					["@type.builtin.rust"] = { fg = colors.cyan },
					["@type.definition.rust"] = { fg = colors.blue1, bold = true },
					["@variable.builtin.rust"] = { fg = colors.red },
					["@variable.member.rust"] = { fg = colors.green1 },
					["@variable.parameter.rust"] = { fg = colors.yellow },
					["@property.rust"] = { fg = colors.green1 },
					["@lsp.type.enum.rust"] = { fg = colors.blue1, bold = true },
					["@lsp.type.interface.rust"] = { fg = colors.yellow, bold = true },
					["@lsp.type.lifetime.rust"] = { fg = colors.magenta },
					["@lsp.type.macro.rust"] = { fg = colors.teal },
					["@lsp.type.method.rust"] = { fg = colors.blue },
					["@lsp.type.namespace.rust"] = { fg = colors.cyan },
					["@lsp.type.property.rust"] = { fg = colors.green1 },
					["@lsp.type.selfKeyword.rust"] = { fg = colors.red },
					["@lsp.type.selfTypeKeyword.rust"] = { fg = colors.red },
					["@lsp.type.struct.rust"] = { fg = colors.blue1, bold = true },
					["@lsp.type.typeAlias.rust"] = { fg = colors.blue1 },
					["@lsp.typemod.variable.static.rust"] = { fg = colors.orange },
				}

				for group, value in pairs(rust_highlights) do
					highlights[group] = value
				end

				highlights.DiagnosticVirtualTextError =
					{ fg = colors.error, bg = util.blend_bg(colors.error, 0.16), bold = true }
				highlights.DiagnosticVirtualTextWarn = { fg = colors.warning, bg = util.blend_bg(colors.warning, 0.12) }
				highlights.DiagnosticVirtualLinesError = { fg = colors.error, bg = util.blend_bg(colors.error, 0.10) }
				highlights.DiagnosticVirtualLinesWarn =
					{ fg = colors.warning, bg = util.blend_bg(colors.warning, 0.08) }
				highlights.DiagnosticUnderlineError = { undercurl = true, sp = colors.error }
				highlights.DiagnosticUnderlineWarn = { undercurl = true, sp = colors.warning }
			end,
		},
	},
	{
		"AstroNvim/astroui",
		opts = {
			colorscheme = "tokyonight",
		},
	},
}

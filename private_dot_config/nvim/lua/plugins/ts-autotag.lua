-- nvim-ts-autotag auto-attaches to Rust (for Leptos's view! macro). When the
-- rust treesitter parser is missing or the buffer isn't fully attached,
-- internal.lua's InsertLeave callback crashes on `parser:parse` with a nil
-- parser. Disable autotag for rust since this config isn't Leptos-oriented.
return {
	"windwp/nvim-ts-autotag",
	opts = {
		per_filetype = {
			rust = {
				enable_rename = false,
				enable_close = false,
				enable_close_on_slash = false,
			},
		},
	},
}

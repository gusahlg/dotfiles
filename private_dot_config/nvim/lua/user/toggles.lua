local M = {}

local function bool_text(value)
	return value and "on" or "off"
end

local function notify(message, level)
	vim.notify(message, level or vim.log.levels.INFO, { title = "Editor toggles" })
end

local function hide_completion_menu()
	local ok, blink = pcall(require, "blink.cmp")
	if ok and blink and blink.hide then
		local hidden, err = pcall(blink.hide)
		if not hidden then
			notify(("Could not hide completion menu: %s"):format(err), vim.log.levels.WARN)
		end
	end
end

function M.toggle_buffer_completion()
	local ok, astrocore = pcall(require, "astrocore")
	if not ok then
		notify("Could not toggle code suggestions: astrocore is unavailable", vim.log.levels.ERROR)
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	if vim.b[bufnr].completion == nil then
		vim.b[bufnr].completion = vim.tbl_get(astrocore.config, "features", "cmp") ~= false
	end

	vim.b[bufnr].completion = not vim.b[bufnr].completion
	if not vim.b[bufnr].completion then
		hide_completion_menu()
	end

	notify(("Code suggestions %s for this buffer"):format(bool_text(vim.b[bufnr].completion)))
end

function M.toggle_global_completion()
	local ok, astrocore = pcall(require, "astrocore")
	if not ok then
		notify("Could not toggle code suggestions: astrocore is unavailable", vim.log.levels.ERROR)
		return
	end

	astrocore.config.features.cmp = not astrocore.config.features.cmp
	if not astrocore.config.features.cmp then
		hide_completion_menu()
	end

	notify(("Code suggestions %s globally"):format(bool_text(astrocore.config.features.cmp)))
end

function M.toggle_diagnostics()
	local enabled = not vim.diagnostic.is_enabled()
	local ok, err = pcall(vim.diagnostic.enable, enabled)
	if not ok then
		notify(("Could not toggle diagnostics: %s"):format(err), vim.log.levels.ERROR)
		return
	end

	notify(("Error detection %s"):format(bool_text(vim.diagnostic.is_enabled())))
end

function M.show_cursor_diagnostics()
	if not vim.diagnostic.is_enabled() then
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local line = vim.api.nvim_win_get_cursor(0)[1] - 1
	if vim.tbl_isempty(vim.diagnostic.get(bufnr, { lnum = line })) then
		return
	end

	vim.diagnostic.open_float(nil, {
		focus = false,
		scope = "cursor",
	})
end

return M

local is_nixos = vim.fn.filereadable("/etc/NIXOS") == 1
local config_dir = vim.fn.stdpath("config")

local server_commands = {
	bashls = "bash-language-server",
	clangd = "clangd",
	cssls = "vscode-css-language-server",
	docker_compose_language_service = "docker-compose-langserver",
	dockerls = "docker-langserver",
	eslint = "vscode-eslint-language-server",
	gopls = "gopls",
	html = "vscode-html-language-server",
	jsonls = "vscode-json-language-server",
	lua_ls = "lua-language-server",
	marksman = "marksman",
	nil_ls = "nil",
	nixd = "nixd",
	pyright = "pyright-langserver",
	rust_analyzer = "rust-analyzer",
	taplo = "taplo",
	terraformls = "terraform-ls",
	ts_ls = "typescript-language-server",
	yamlls = "yaml-language-server",
	zls = "zls",
}

local preferred_servers = {
	"lua_ls",
	"nixd",
	"rust_analyzer",
	"clangd",
	"pyright",
	"ts_ls",
	"eslint",
	"bashls",
	"jsonls",
	"yamlls",
	"taplo",
	"marksman",
	"dockerls",
	"docker_compose_language_service",
	"html",
	"cssls",
	"gopls",
	"terraformls",
	"zls",
}

local function executable(cmd)
	return vim.fn.executable(cmd) == 1
end

local function has_config_flake()
	return vim.fn.filereadable(config_dir .. "/flake.nix") == 1
end

local function can_use_nix_tool(server)
	return is_nixos and server == "rust_analyzer" and executable("nix") and has_config_flake()
end

local function server_command(server)
	return server_commands[server] or server
end

local function nix_develop_command(cmd)
	return { "nix", "develop", "path:" .. config_dir, "--command", cmd }
end

local function lsp_command(server)
	local cmd = server_command(server)
	if executable(cmd) then
		return nil
	end
	if can_use_nix_tool(server) then
		return nix_develop_command(cmd)
	end
end

local function available(server)
	return executable(server_command(server)) or can_use_nix_tool(server)
end

local function enabled_servers()
	if not is_nixos then
		return preferred_servers
	end

	local servers = {}
	for _, server in ipairs(preferred_servers) do
		if server == "nixd" then
			if available("nixd") then
				table.insert(servers, "nixd")
			elseif available("nil_ls") then
				table.insert(servers, "nil_ls")
			end
		elseif available(server) then
			table.insert(servers, server)
		end
	end

	return servers
end

return {
	"AstroNvim/astrolsp",
	opts = {
		features = {
			codelens = true,
			inlay_hints = true,
			semantic_tokens = true,
		},
		formatting = {
			format_on_save = false,
			timeout_ms = 2000,
		},
		servers = enabled_servers(),
		config = {
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = "LuaJIT" },
						diagnostics = { globals = { "vim" } },
						telemetry = { enable = false },
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
					},
				},
			},
			nil_ls = {
				settings = {
					["nil"] = {
						formatting = { command = { "nixfmt" } },
					},
				},
			},
			nixd = {
				settings = {
					nixd = {
						formatting = { command = { "nixfmt" } },
						nixpkgs = {
							expr = "import <nixpkgs> { }",
						},
					},
				},
			},
			rust_analyzer = {
				cmd = lsp_command("rust_analyzer"),
				settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						completion = {
							autoimport = { enable = true },
							autoself = { enable = true },
							postfix = { enable = true },
						},
						check = { command = "clippy" },
						diagnostics = { enable = true },
						imports = {
							granularity = { group = "module" },
							prefix = "self",
						},
						lens = { enable = true },
						procMacro = { enable = true },
					},
				},
			},
			yamlls = {
				settings = {
					yaml = {
						keyOrdering = false,
					},
				},
			},
		},
		mappings = {
			n = {
				gd = {
					function()
						vim.lsp.buf.definition()
					end,
					desc = "Definition",
					cond = "textDocument/definition",
				},
				gD = {
					function()
						vim.lsp.buf.declaration()
					end,
					desc = "Declaration",
					cond = "textDocument/declaration",
				},
				gi = {
					function()
						vim.lsp.buf.implementation()
					end,
					desc = "Implementation",
					cond = "textDocument/implementation",
				},
				gr = {
					function()
						vim.lsp.buf.references()
					end,
					desc = "References",
					cond = "textDocument/references",
				},
				K = {
					function()
						vim.lsp.buf.hover()
					end,
					desc = "Hover documentation",
					cond = "textDocument/hover",
				},
				["<C-h>"] = {
					function()
						vim.lsp.buf.signature_help()
					end,
					desc = "Signature help",
					cond = "textDocument/signatureHelp",
				},
				["<leader>rn"] = {
					function()
						vim.lsp.buf.rename()
					end,
					desc = "Rename symbol",
				},
				["<leader>ca"] = {
					function()
						vim.lsp.buf.code_action()
					end,
					desc = "Code action",
				},
				["[d"] = {
					function()
						vim.diagnostic.jump({ count = -1, float = true })
					end,
					desc = "Previous diagnostic",
				},
				["]d"] = {
					function()
						vim.diagnostic.jump({ count = 1, float = true })
					end,
					desc = "Next diagnostic",
				},
				["[e"] = {
					function()
						vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
					end,
					desc = "Previous error",
				},
				["]e"] = {
					function()
						vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
					end,
					desc = "Next error",
				},
				["<leader>e"] = {
					function()
						vim.diagnostic.open_float()
					end,
					desc = "Line diagnostics",
				},
				["<leader>q"] = {
					function()
						vim.diagnostic.setloclist()
					end,
					desc = "Diagnostics loclist",
				},
			},
			i = {
				["<C-h>"] = {
					function()
						vim.lsp.buf.signature_help()
					end,
					desc = "Signature help",
					cond = "textDocument/signatureHelp",
				},
			},
		},
	},
}

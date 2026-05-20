# AstroNvim config

This config is a small AstroNvim v6 setup. `init.lua` bootstraps
`lazy.nvim`, `lua/lazy_setup.lua` loads AstroNvim itself, and local plugin
overrides live in `lua/plugins/`. Final one-off editor tweaks live in
`lua/polish.lua`.

## Architecture

- `init.lua`: bootstraps `lazy.nvim`, then loads `lazy_setup` and `polish`.
- `lua/lazy_setup.lua`: imports AstroNvim, `community.lua`, and every module in `lua/plugins/`.
- `lua/plugins/astrocore.lua`: core options, diagnostics UI, clipboard/search mappings, Snacks picker mappings.
- `lua/plugins/astrolsp.lua`: language server list, server settings, Rust analyzer settings, LSP keymaps.
- `lua/plugins/blink.lua`: completion menu, docs popup, ghost text, and completion keymaps.
- `lua/plugins/treesitter.lua`: parser list and Treesitter highlighting/indent setup.
- `lua/plugins/mason.lua`: Mason behavior, with NixOS-safe PATH handling.
- `lua/plugins/theme.lua`: Tokyonight theme and stronger Rust/diagnostic highlights.
- `lua/plugins/harpoon.lua`: Harpoon file marks and quick navigation.
- `flake.nix`: reproducible dev shell for Neovim, LSPs, Treesitter tools, Rust tools, and formatters.

## Features

- Rust: Treesitter highlighting, Rust LSP semantic tokens, inlay hints, proc macro support, clippy diagnostics, auto-import completion.
- Diagnostics: signs, underlines, virtual text, current-line virtual diagnostic lines, diagnostic float on `CursorHold`, diagnostic pickers.
- Completion: `blink.cmp` with LSP, path, snippets, and buffer sources. Use `<C-Space>` to open, `<Tab>` or `<CR>` to accept, `<C-n>/<C-p>` to move, and `<C-e>` to cancel.
- LSP navigation: `gd`, `gD`, `gi`, `gr`, `K`, `<leader>rn`, `<leader>ca`, `[d`, `]d`, `[e`, `]e`, `<leader>e`, `<leader>q`.
- Toggles: `<leader>uc` toggles code suggestions for the current buffer, `<leader>uC` toggles code suggestions globally, and `<leader>ud` toggles diagnostics/error detection.
- Editing basics: relative numbers, cursorline, system clipboard, centered search/page movement, visual selection movement, paste-without-yank.
- Search/navigation: Snacks file/grep/buffer/help/diagnostic pickers and Harpoon quick file slots.
- NixOS behavior: Mason does not prepend its binary directory to `PATH`. Servers are normally enabled only when available from the environment, while Rust analyzer can fall back through this config's flake.

## NixOS language tools

The included `flake.nix` provides a dev shell with Neovim, search tools, compilers for Treesitter parsers, and common language servers:

```sh
nix develop path:$HOME/.config/nvim
nvim
```

For a permanent NixOS or Home Manager setup, install equivalent packages from the dev shell into your system or user profile. For Rust specifically, make sure `rust-analyzer`, `cargo`, `rustc`, `clippy`, and `rustfmt` are available.

On NixOS, Mason is still available for browsing tools, but its bin directory is not prepended to `PATH`. This prevents generic Linux Mason binaries from shadowing Nix-provided language servers.

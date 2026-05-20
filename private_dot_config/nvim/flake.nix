{
  description = "Development shell for this AstroNvim configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              neovim
              git
              ripgrep
              fd
              gcc
              gnumake
              tree-sitter

              rustc
              cargo
              clippy
              rustfmt
              lua-language-server
              nil
              nixd
              nixfmt
              rust-analyzer
              clang-tools
              pyright
              typescript-language-server
              eslint_d
              bash-language-server
              vscode-langservers-extracted
              yaml-language-server
              taplo
              marksman
              dockerfile-language-server
              docker-compose-language-service
              gopls
              terraform-ls
              zls

              stylua
              shfmt
              shellcheck
              prettierd
              black
              isort
            ];
          };
        }
      );
    };
}

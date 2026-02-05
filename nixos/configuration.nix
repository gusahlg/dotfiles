{ config, lib, pkgs, ... }:

let
  # Import nixos-unstable only for select packages (e.g. Neovim 0.11+)
  unstable = import (fetchTarball "https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz") {
    inherit (pkgs) system;
    config = config.nixpkgs.config;
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  time.timeZone = "Europe/Stockholm";
  console.keyMap = "sv-latin1";

  # Wayland + River
  programs.river.enable = true;

  services.greetd.enable = true;
  services.greetd.settings.default_session = {
    command = "${pkgs.river}/bin/river";
    user = "gusahlg";
  };

  environment.systemPackages = with pkgs; [
    unstable.neovim
    vim
    alacritty
    tmux
    fish
    bash
    firefox
    vesktop
    chezmoi

    # Wayland deps
    wlr-randr
    wl-clipboard
    wofi
    waybar
    grim
    slurp

    # Necessities
    git
    htop

    # Package deps
    ripgrep
    fd
    gcc
    cargo
    rustc
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  hardware.opengl.enable = true;

  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish ];

  users.users.gusahlg = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "24.11";
}


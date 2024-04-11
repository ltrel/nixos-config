{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    neovim
    tree
    htop
    wget
    ranger
    neofetch
    nixos-option
    nodejs
    uxn
    # Graphical
    firefox-wayland
    discord
    maliit-keyboard
    gimp
  ];
}

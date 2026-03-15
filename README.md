# Caturday's Dotfiles

They use nix, nixOS and nix-darwin to setup their development env
and share common aspects across systems. The editor of their choice
is Neovim. You can get a copy of configuraion in this repo

To get started, symbolically link per system as follows

## NixOS

| Source             | Dest                   |
| :----------------- | :--------------------- |
| nixos/etc          | /etc/nixos             |
| nixos/home-manager | ~/.config/home-manager |
| nvim               | ~/.config/nvim         |

## macOS

| Source     | Dest              |
| :--------- | :---------------- |
| nix-pkgs   | ~/.config/nixpkgs |
| nix-darwin | /etc/nix-darwin   |
| nvim       | ~/.config/nvim    |

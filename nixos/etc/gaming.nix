{ pkgs, nix-gaming-edge, ... }:
{
  imports = [
    nix-gaming-edge.nixosModules.default
  ];

  # destructure module args by 'importing' pkgs - only needed when defining a protonPackage
  nixpkgs.overlays = [
    nix-gaming-edge.overlays.default
    (final: prev: {
      gamemode = pkgs.callPackage ../../nix-common/gamemode.nix { };
    })
    # nix-gaming-edge.overlays.mesa-git
    # nix-gaming-edge.overlays.proton-cachyos
    # nix-gaming-edge.overlays.vintagestory
    # etc.
  ];

  environment.systemPackages = [ pkgs.gamemode ];

  hardware.steam-hardware.enable = true; # controller / Steam Deck input udev rules
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-cachyos
      proton-ge-bin
    ];
    extraPackages = with pkgs; [
      gamemode
    ];
  };
}

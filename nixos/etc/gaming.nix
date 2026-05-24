{ pkgs, nix-gaming-edge, ... }:
{
  imports = [
    nix-gaming-edge.nixosModules.default
  ];
  # destructure module args by 'importing' pkgs - only needed when defining a protonPackage
  nix.settings = {
    # set the binary cache declaratively - optional
    substituters = [ "https://nix-cache.tokidoki.dev/tokidoki" ];
    trusted-public-keys = [ "tokidoki:MD4VWt3kK8Fmz3jkiGoNRJIW31/QAm7l1Dcgz2Xa4hk=" ];
  };

  nixpkgs.overlays = [
    nix-gaming-edge.overlays.default
    # nix-gaming-edge.overlays.mesa-git
    # nix-gaming-edge.overlays.proton-cachyos
    # nix-gaming-edge.overlays.vintagestory
    # etc.
  ];

  hardware.steam-hardware.enable = true; # controller / Steam Deck input udev rules
  programs.steam = {
    # package = pkgs.millennium-steam
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-cachyos
      proton-ge-bin
    ];
  };
}

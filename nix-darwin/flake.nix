{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    macos-cross-toolchains = {
      url = "github:messense/macos-cross-toolchains";
      flake = false;
    };
    tw93 = {
      url = "github:tw93/homebrew-tap";
      flake = false;
    };
  };

  outputs =
    inputs@{ self, nix-darwin, ... }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#zhusmacmini
      darwinConfigurations."zhusmacmini" = nix-darwin.lib.darwinSystem {
        modules = (import ./modules.nix) inputs;
      };

      darwinConfigurations."zhufusmbp" = nix-darwin.lib.darwinSystem {
        modules = (import ./modules.nix) inputs;
      };

      darwinConfigurations."zhufusmba" = nix-darwin.lib.darwinSystem {
        modules = (import ./modules.nix) inputs;
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."zhusmacmini".pkgs;
    };
}

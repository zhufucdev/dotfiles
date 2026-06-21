{
  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    not-yet = {
      url = "github:zhufucdev/not-yet";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ledoxide = {
      url = "github:zhufucdev/ledoxide";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming-edge = {
      url = "github:powerofthe69/nix-gaming-edge";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ollama = {
      url = "github:zhufucdev/ollama";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rlamus = {
      url = "github:sumalr-developers/rlamus";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      sops-nix,
      not-yet,
      ledoxide,
      nix-gaming-edge,
      ollama,
      rlamus,
      ...
    }:
    {
      nixosConfigurations.functionaltux = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit nix-gaming-edge; };
        modules = [
          ./configuration.nix
          ./gaming.nix
          sops-nix.nixosModules.sops
          not-yet.nixosModules.telegram
          ledoxide.nixosModules.ledoxide
          ledoxide.nixosModules.package
          ollama.nixosModules.default
          rlamus.nixosModules.server
        ];
      };
    };
}

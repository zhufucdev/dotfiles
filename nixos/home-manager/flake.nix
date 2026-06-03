{
  description = "Home Manager configuration of steve";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tree-sitter.url = "github:tree-sitter/tree-sitter";
    llama-cpp.url = "github:ggml-org/llama.cpp";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      tree-sitter,
      llama-cpp,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."caturday" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home.nix
          {
            nixpkgs.overlays = [
              (final: prev: {
                tree-sitter-latest = tree-sitter.packages.${final.stdenv.system}.cli;
                llama-cpp-rocm = llama-cpp.packages.${final.stdenv.system}.rocm;
              })
              (final: prev: {
                gaphor = prev.gaphor.overrideAttrs (old: {
                  doCheck = false;
                  doInstallCheck = false;
                });
              })
            ];
          }
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}

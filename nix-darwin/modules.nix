{
  self,
  home-manager,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  tree-sitter,
  tw93,
  zewo,
  shichizip,
  ...
}:
[
  home-manager.darwinModules.home-manager
  {
    home-manager = {
      users.zhufu = ./home;
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
    };
    users.users.zhufu.home = "/Users/zhufu";
  }
  nix-homebrew.darwinModules.nix-homebrew
  {
    nix-homebrew = {
      enable = true;
      user = "zhufu";
      taps = {
        "homebrew/homebrew-core" = homebrew-core;
        "homebrew/homebrew-cask" = homebrew-cask;
        "tw93/homebrew-tap" = tw93;
        "zewo/homebrew-tap" = zewo;
        "shichizip/homebrew-tap" = shichizip;
      };
      mutableTaps = false;
      autoMigrate = true;
      trust = {
        taps = [
          "tw93/homebrew-tap"
          "zewo/homebrew-tap"
          "Sikarugir-App/sikarugir"
          "shichizip/homebrew-tap"
        ];
      };
    };
  }
  ./postgres.nix
  {
    nixpkgs.overlays = [
      (final: prev: {
        tree-sitter-latest = tree-sitter.packages.${prev.stdenv.hostPlatform.system}.cli;
      })
    ];
  }
  ./configuration.nix
]

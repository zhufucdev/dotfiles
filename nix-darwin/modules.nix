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
  sikarugir,
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
        "sikarugir-app/homebrew-sikarugir" = sikarugir;
      };
      mutableTaps = false;
      autoMigrate = true;
      trust = {
        taps = [
          "tw93/homebrew-tap"
          "zewo/homebrew-tap"
          "sikarugir-app/homebrew-sikarugir"
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
        poetry = prev.poetry.overrideAttrs (
          final: prev: {
            disabledTests = prev.disabledTests ++ [
              "test_execute_executes_a_batch_of_operations"
              "test_execute_prints_warning_for_yanked_package[operations1-False]"
              "test_execute_prints_warning_for_yanked_package[operations2-True]"
            ];
          }
        ); # TODO: disabled for now
      })
    ];
  }
  ./configuration.nix
]

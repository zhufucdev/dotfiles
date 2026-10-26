{
  home-manager,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  tree-sitter,
  tw93,
  zewo,
  shichizip,
  sikarugir,
  ledoxide,
  sops-nix,
  nix-spotlight,
  omp,
  yabai,
  scaledaemon,
  ...
}:
[
  home-manager.darwinModules.home-manager
  {
    home-manager = {
      sharedModules = [ nix-spotlight.homeManagerModules.default ];
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
        omp = omp.packages.${prev.stdenv.hostPlatform.system}.default;
        yabai = yabai.packages.${prev.stdenv.hostPlatform.system}.default;
        python313Packages = prev.python313Packages // {
          debugpy = prev.python313Packages.debugpy.overrideAttrs (
            final: prev: {
              disabledTests = prev.disabledTests ++ [
                "test_lldb_command"
              ];
            }
          ); # TODO: disabled for now
        };
      })
    ];
  }
  ledoxide.darwinModules.ledoxide
  ledoxide.darwinModules.package
  scaledaemon.darwinModules.default
  sops-nix.darwinModules.sops
  ./configuration.nix
]

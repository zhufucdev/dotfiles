let
  toolchains =
    { self }:
    { pkgs, config, ... }:
    {
      environment.systemPackages = with pkgs; [
        vim
        home-manager
        git
        curl
        tmux
        xz
        gnupg
        nixd
        nixfmt
        watch
        fzf
        ripgrep
        llama-cpp
        ninja
      ];

      environment.pathsToLink = [ "/share/zsh" ];

      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true; # default shell on catalina
      # programs.fish.enable = true;

      programs.direnv.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      system.primaryUser = "zhufu";

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      nixpkgs.config = {
        allowUnfree = true;
      };

      homebrew = {
        enable = true;
        brews = [
          "tw93/tap/mole"
          "zewo/tap/libdill"
        ];
        #Align homebrew taps config with nix-homebrew
        taps = builtins.attrNames config.nix-homebrew.taps;
        casks = [
          "Sikarugir-App/sikarugir/sikarugir"
          "gaphor"
          "shichizip"
        ];
      };
    };
in
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
  (toolchains { inherit self; })
]

let
  toolchains =
    { self }:
    { pkgs, ... }:
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
      ];

      environment.pathsToLink = [ "/share/zsh" ];

      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true; # default shell on catalina
      # programs.fish.enable = true;

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
        brews = [ ];
      };
    };
in
{
  self,
  home-manager,
  nix-homebrew,
  homebrew-core,
  homebrew-cask,
  macos-cross-toolchains,
  laishulu,
  ...
}:
[
  (toolchains { inherit self; })
  home-manager.darwinModules.home-manager
  {
    home-manager = {
      users.zhufu = ./home;
      useGlobalPkgs = true;
      useUserPackages = true;
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
        "messense/macos-cross-toolchains" = macos-cross-toolchains;
        "laishulu/homebrew" = laishulu;
      };
    };
  }
  #Align homebrew taps config with nix-homebrew
  (
    { config, ... }:
    {
      homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
    }
  )
  ./postgres.nix
]

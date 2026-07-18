{
  pkgs,
  config,
  ...
}:
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
}

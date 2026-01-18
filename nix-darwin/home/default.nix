{ config, pkgs, ... }:
{
  home = {
    username = "zhufu";
    homeDirectory = "/Users/zhufu";
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    go
    rustup
    pyenv
    uv
    nodejs_22
    pnpm
    git-lfs
    git-filter-repo
    mcfly
    prettierd
    monocraft
    nerd-fonts.jetbrains-mono
    python313Packages.debugpy
    macism
    raycast
    neovide
    openapi-generator-cli
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "less";
    GOPATH = "$HOME/go";
    CARGO_HOME = "$HOME/.cargo";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$GOPATH/bin"
    "$CARGO_HOME/bin"
  ]
  ++ (import ./path.nix);

  programs.java = (import ./java.nix) { inherit pkgs; };

  programs.poetry.enable = true;

  programs.git = (import ../../nix-common/git.nix);

  programs.gh.enable = true;

  programs.neovim.enable = true;

  programs.zsh = (import ../../nix-common/zsh.nix) { inherit config; } // {
    shellAliases = {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
      adb = "/Users/zhufu/Library/Android/sdk/platform-tools/adb";
      fastboot = "/Users/zhufu/Library/Android/sdk/platform-tools/fastboot";
    };
  };

  fonts.fontconfig.enable = true;
}

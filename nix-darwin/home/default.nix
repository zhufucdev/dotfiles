{config, pkgs, ...}: {
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
    git-lfs
    git-filter-repo
    mcfly
    prettierd
    nerd-fonts.jetbrains-mono
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
  ] ++ (import ./path.nix);

  programs.java = (import ./java.nix) { inherit pkgs; };

  programs.poetry.enable = true;

  programs.git = (import ./git.nix);

  programs.gh.enable = true;

  programs.neovim.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      tailscale = "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
      adb = "/Users/zhufu/Library/Android/sdk/platform-tools/adb";
      fastboot = "/Users/zhufu/Library/Android/sdk/platform-tools/fastboot";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    initContent = ''
    export MCFLY_FUZZY=2
    eval "$(pyenv init -)"
    eval "$(mcfly init zsh)"
    bindkey ';3C' forward-word
    bindkey ';3D' backward-word
    '' + (builtins.readFile ./zshrc);

    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
        { name = "0i0/0i0.zsh-theme"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
        { name = "zsh-users/zsh-history-substring-search"; tags = [ as:plugin ]; }
      ];
    };
  };

  fonts.fontconfig.enable = true;
}

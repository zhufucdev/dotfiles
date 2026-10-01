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
    nix-output-monitor
    jdk25
    sops
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

  services.openssh = {
    enable = true;
    extraConfig = ''
      PasswordAuthentication no
      ChallengeResponseAuthentication no
    '';
  };

  services.ledoxide = {
    enable = true;
    package = pkgs.ledoxide-openai;
    authKeyFile = "/var/run/secrets/ledoxide";
    captionModel = "Qwen3.8-27B-oQ4e-mtp";
    extractModel = "Qwen3.8-27B-oQ4e-mtp";
    extraOpts = ''
      -c Transport -c Rent -c Entertainment
          -c Drink -c Food -c Groceries -c Health 
          -c Salary -c Shopping  -c "Credit repay"'';
  };

  services.yabai = {
    enable = true;
    config = {
      focus_follows_mouse = "autoraise";
      mouse_follows_focus = "off";
      top_padding = 0;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 0;
      layout = "bsp";
      window_animation_duration = 1;
      window_shadow = "off";
      window_opacity = "on";
      active_window_opacity = "1";
      normal_window_opacity = "0.4";
      insert_feedback_color = "#F7821B";
    };
    extraConfig = ''
      yabai -m rule --add app='System Settings' manage=off
      yabai -m rule --add app='Tailscale' manage=off
    '';
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      fn - escape : yabai -m window --toggle float
    '';
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  nixpkgs.config = {
    allowUnfree = true;
  };

  homebrew = {
    enable = true;
    brews = [
      "tw93/tap/mole"
      "xcode-build-server"
      "swift-protobuf"
    ];
    # Align homebrew taps config with nix-homebrew
    taps = builtins.attrNames config.nix-homebrew.taps;
    casks = [
      "Sikarugir-App/sikarugir/sikarugir"
      "gaphor"
      "shichizip"
      "proxy-audio-device"
      "apparency"
    ];
  };

  sops = {
    defaultSopsFile = ./secrets/default.yaml;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      # This will generate a new key if the key specified above does not exist
      generateKey = true;
    };
    secrets = {
      "ledoxide" = {
        format = "dotenv";
        sopsFile = ./secrets/ledoxide.env;
        mode = "444";
      };
    };
  };
}

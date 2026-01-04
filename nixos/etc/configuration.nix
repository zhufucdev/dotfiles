# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use LTS kernel
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  # ZFS support
  networking = {
    hostId = "e99f7b6a";

    hostName = "functionaltux"; # Define your hostname.

    # Configure network connections interactively with nmcli or nmtui.
    networkmanager.enable = true;

    # Configure network proxy if necessary
    proxy.default = "http://localhost:7890";
    proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    bridges.br0.interfaces = [
      "enp37s0"
      "enp38s0"
    ];
    useDHCP = false;

    interfaces.br0.ipv4.addresses = [
      {
        address = "192.168.124.10";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.124.1";
    nameservers = [ "192.168.124.1" ];
  };

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Samba share zfs pool
  services.samba = {
    enable = true;
    package = pkgs.sambaFull;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "functionaltux";
        "netbios name" = "functionaltux";
        "security" = "user";

        "guest account" = "nobody";

        "usershare path" = "/var/lib/samba/usershares";
        "usershare max shares" = "100";
        "usershare allow guests" = "yes";
        "usershare owner only" = "no";
      };
    };
    openFirewall = true;
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
    };
    allowInterfaces = [ config.networking.interfaces.br0.name ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.steve = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "uinput"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+cV1MGvbTix/2rL1cUMfLbbhBXwOutUwNUNYle+c5F zhufu@zhufusmbp.local"
    ];
  };
  # programs.firefox.enable = true;
  programs.zsh.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    git
    rsync
    gparted
    zip
    unzip
    gcc
    nixd
    nixfmt
    file
    lsof
    neovide
    gnome-console
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "steve" ];
    };
  };

  programs.steam.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable mihomo service
  services.mihomo = {
    enable = true;
    configFile = "/etc/mihomo/config.yml";
    tunMode = true;
  };

  # Minimal Gnome desktop environment
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome = {
    core-apps.enable = false;
    core-developer-tools.enable = false;
    games.enable = false;
  };
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "steve";

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
    package = pkgs.sunshine.override { cudaSupport = true; };
  };
  hardware.uinput.enable = true;

  # Tailscale
  services.tailscale.enable = true;

  services.cron =
    if builtins.pathExists ./system-cron.local.nix then
      import ./system-cron.local.nix { inherit lib pkgs; }
    else
      { };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;
  nix.settings = {
    experimental-features = "nix-command flakes";
    # CUDA cache
    substituters = [ "https://cache.nixos-cuda.org" ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };

  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

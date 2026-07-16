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
    ./qbittorent.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use LTS kernel
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  # ZFS support
  networking = {
    hostId = "e99f7b6a";

    hostName = "functionaltux"; # Define your hostname.

    # Configure network connections interactively with nmcli or nmtui.
    networkmanager.enable = true;

    bridges.br0.interfaces = [
      "enp37s0"
      "enp38s0"
    ];
    useDHCP = false;

    interfaces.br0 = {
      ipv4.addresses = [
        {
          address = "192.168.124.10";
          prefixLength = 24;
        }
      ];
      mtu = 9000;
    };
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
    package = pkgs.samba.override {
      enableLDAP = true;
      enablePrinting = true;
      enableMDNS = true;
      enableDomainController = true;
      enableRegedit = true;
    };
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "functionaltux";
        "netbios name" = "functionaltux";
        "security" = "user";

        "guest account" = "sambaguest";
        "map to guest" = "bad user";
        "access based share enum" = "yes";

        "usershare path" = "/var/lib/samba/usershares";
        "usershare max shares" = "100";
        "usershare allow guests" = "no";
        "usershare owner only" = "no";
      };
      public = {
        "path" = "/mnt/pool/public";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
      };

      caturday_home = {
        "path" = "/home/caturday/share";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "caturday";
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

  users.mutableUsers = false;
  users.users = {
    # Define a user account. Password is kept as screts.
    caturday = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "networkmanager"
        "uinput"
        "docker"
      ];
      shell = pkgs.zsh;
      hashedPasswordFile = config.sops.secrets.caturday-pwd.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+cV1MGvbTix/2rL1cUMfLbbhBXwOutUwNUNYle+c5F zhufu@zhufusmbp.local"
      ];
    };
    sambaguest = {
      isNormalUser = true;
      shell = pkgs.shadow; # No login
    };
  };

  programs.firefox.enable = true;
  programs.chromium.enable = true;
  programs.zsh.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

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
    gnome-console
    sops
    age
    # not-yet
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    chromium
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
      AllowUsers = [
        "caturday"
      ];
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable mihomo service
  services.mihomo = {
    enable = true;
    configFile = config.sops.secrets.mihomo.path;
    tunMode = true;
    processesInfo = true;
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
  services.displayManager.autoLogin.user = "caturday";

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
    package = pkgs.sunshine;
    settings = {
      csrf_allowed_origins = "https://sunshine.tail8a9e0.ts.net";
    };
  };
  hardware.uinput.enable = true;

  # Tailscale
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
    extraDaemonFlags = [
      "--tun=userspace-networking"
      "--socks5-server=0.0.0.0:1099"
    ];
    extraSetFlags = [
      "--advertise-exit-node"
      "--accept-dns=false"
    ];
    extraUpFlags = [
      "--advertise-connector"
      "--advertise-exit-node"
      "--exit-node-allow-lan-access"
      "--advertise-tags=tag:qbittorent-web"
    ];
  };

  services.cron = {
    enable = false;
    systemCronJobs = [ ];
  };

  services.ledoxide = {
    enable = true;
    authKeyFile = "/var/run/secrets/ledoxide";
    captionModel = "gemma4-uncensored:12b";
    extractModel = "gemma4:e4b";
    extraEnv = "RUST_LOG=debug";
    extraOpts = "--offline";
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    hardwareAcceleration = {
      enable = true;
      device = "/dev/dri/renderD128";
    };
  };

  # ollama
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    environmentVariables = {
      OLLAMA_ORIGINS = "https://ollama.tail8a9e0.ts.net";
      OLLAMA_CONTEXT_LENGTH = "128000";
    };
    host = "[::]";
  };

  services.not-yet = {
    enable = true;
    package = pkgs.not-yet.override {
      features = [
        "telegram"
        "serve-rss"
        "daemon"
      ];
    };
    extraEnv = ''RUST_LOG="warn,lib_common::polling::schedule=DEBUG" NOT_YET_MODEL="gemma4:12b"'';
  };

  services.rlamus = {
    user = "rlamus";
    enable = true;
    bind = "[::]:54813";
    extraOpts = "--apn-p12 ${config.sops.secrets.rlamus-apn-p12.path}";
    extraEnv = "REDDIT_HEADERS=file:${config.sops.secrets.rlamus-reddit.path} APN_P12_PASSWORD=file:${config.sops.secrets.rlamus-apn-p12-password.path} EMBEDDING_MODEL=\"hf.co/jinaai/jina-embeddings-v5-text-small-clustering:Q8_0\"";
  };

  # Observability
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 58193;
        enable_gzip = true;
        domain = "grafana.tail8a9e0.ts.net";
        root_url = "https://grafana.tail8a9e0.ts.net/";
      };
      security.secret_key = "$__file{${config.sops.secrets.grafana.path}}";
      analytics.reporting_enabled = false;
    };

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
          isDefault = true;
          editable = false;
        }
      ];
    };
  };
  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
    port = 64321;
    globalConfig.scrape_interval = "10m";
    scrapeConfigs = [
      {
        job_name = "quanwutong";
        static_configs = [
          {
            targets = [ config.services.quanwutong-exporter.listenAddress ];
          }
        ];
      }
      {
        job_name = "site";
        scrape_interval = "1h";
        static_configs = [
          {
            targets =
              let
                cfg = config.services.site-exporter;
              in
              [ "${if cfg.interface != null then cfg.interface else "127.0.0.1"}:${toString cfg.port}" ];
          }
        ];
      }
    ];
  };
  services.quanwutong-exporter = {
    enable = true;
    user = "quanwutong-exporter";
    listenAddress = "127.0.0.1:65281";
    token = "file:${config.sops.secrets.quanwutong-token.path}";
  };
  services.site-exporter = {
    enable = true;
    user = "site-exporter";
    dbUrl = "file:${config.sops.secrets.site-db-url.path}";
    port = 61298;
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
      "mihomo" = {
        format = "yaml";
        sopsFile = ./secrets/mihomo.yaml;
        mode = "444";
        key = ""; # Requires the plain file
        neededForUsers = true;
        restartUnits = [ "mihomo.service" ];
      };
      "caturday-pwd" = {
        format = "binary";
        sopsFile = ./secrets/caturday_pwd.bin;
        mode = "444";
        neededForUsers = true;
      };
      "rlamus-reddit" = {
        format = "binary";
        sopsFile = ./secrets/rlamus_reddit.toml;
        mode = "400";
        owner = config.systemd.services.rlamus.serviceConfig.User;
        restartUnits = [ "rlamus.service" ];
      };
      "rlamus-apn-p12" = {
        format = "binary";
        sopsFile = ./secrets/rlamus_apn.p12;
        mode = "400";
        owner = config.systemd.services.rlamus.serviceConfig.User;
        restartUnits = [ "rlamus.service" ];
      };
      "rlamus-apn-p12-password" = {
        format = "binary";
        sopsFile = ./secrets/rlamus_apn_password.txt;
        mode = "400";
        owner = config.systemd.services.rlamus.serviceConfig.User;
        restartUnits = [ "rlamus.service" ];
      };
      "grafana" = {
        format = "binary";
        sopsFile = ./secrets/grafana.txt;
        owner = config.systemd.services.grafana.serviceConfig.User;
        mode = "400";
        restartUnits = [ "grafana.service" ];
      };
      "quanwutong-token" = {
        format = "binary";
        sopsFile = ./secrets/quanwutong.txt;
        mode = "400";
        owner = config.systemd.services.quanwutong-exporter.serviceConfig.User;
        restartUnits = [ "quanwutong-exporter.service" ];
      };
      "site-db-url" = {
        format = "binary";
        sopsFile = ./secrets/site_db_url.txt;
        mode = "400";
        owner = config.systemd.services.site-exporter.serviceConfig.User;
        restartUnits = [ "site-exporter.service" ];
      };
    };
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      fixed-cidr-v6 = "fd00::/80";
      ipv6 = true;
      live-restore = true;
    };
  };

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

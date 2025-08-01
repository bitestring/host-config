# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  host,
  user,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Enable Nix experimental features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set QEMU emulation for cross compilation
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "x86_64-windows"
  ];

  # Filesystem
  fileSystems =
    let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [
          "ro"
          "resolve-symlinks"
          "x-gvfs-hide"
        ];
      };
      aggregatedIcons = pkgs.buildEnv {
        name = "system-icons";
        paths = with pkgs; [
          gnome-themes-extra
          hicolor-icon-theme
        ];
        pathsToLink = [ "/share/icons" ];
      };
      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.packages;
        pathsToLink = [ "/share/fonts" ];
      };
    in
    {
      "/".options = [
        "compress=zstd"
        "relatime"
      ];

      # Create an FHS mount to support flatpak host icons/fonts
      "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
      "/usr/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";

      # Mount virtiofs shared by host
      "/home/${user.name}/data/vm-shared" = {
        device = "vm-shared";
        fsType = "virtiofs";
        options = [
          "defaults"
          "nofail"
        ];
      };
    };

  # Swap
  zramSwap.enable = true;

  networking.hostName = host.name; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalization properties.
  i18n = {
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "en_IN/UTF-8"
    ];
    defaultLocale = "en_IN.UTF-8";
    extraLocaleSettings = {
      LC_ALL = "en_IN.UTF-8";
      LC_ADDRESS = "en_IN.UTF-8";
      LC_IDENTIFICATION = "en_IN.UTF-8";
      LC_MEASUREMENT = "en_IN.UTF-8";
      LC_MONETARY = "en_IN.UTF-8";
      LC_NAME = "en_IN.UTF-8";
      LC_NUMERIC = "en_IN.UTF-8";
      LC_PAPER = "en_IN.UTF-8";
      LC_TELEPHONE = "en_IN.UTF-8";
      LC_TIME = "en_IN.UTF-8";
    };
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable automatic login for the user.
  services.displayManager.autoLogin.user = user.name;

  # Enable GNOME Keyring
  services.gnome.gnome-keyring.enable = true;
  # Auto-unlock keyring on login
  security.pam.services.login.enableGnomeKeyring = true;

  # Turn off all power management and auto suspend features
  powerManagement.enable = false;
  services.logind.extraConfig = ''
    HandlePowerKey=ignore
    HandleSuspendKey=ignore
    HandleHibernateKey=ignore
  ''; # https://nixos.wiki/wiki/Logind
  # Disable sleep in systemd
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Shell
  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user.name} = {
    isNormalUser = true;
    description = user.description;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    linger = true; # Keep running systemd user services even if logged out
    shell = pkgs.fish;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    # wget
    curl
    git
    gnumake
    bindfs
    sysprof
    docker-compose
    gnome-tweaks
    gnome-software
  ];

  # Virtualization and Containers
  virtualisation = {
    containers.enable = true;
    oci-containers.backend = "podman";

    # https://wiki.nixos.org/wiki/Podman
    podman = {
      enable = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };

    # https://wiki.nixos.org/wiki/Docker
    docker = {
      enable = false; # Don't run Docker as rootful system daemon
      enableOnBoot = false;
      storageDriver = "btrfs";

      # Use the rootless mode - run Docker daemon as non-root user
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };

  # Virtualization guest drivers & agents
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # List services that you want to enable:
  services.cockpit.enable = true;
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    openFirewall = true;
  };

  services.fstrim.enable = true;
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/"
    ];
  };

  services.flatpak.enable = true;
  services.sysprof.enable = true;
  services.tor = {
    enable = false;
    client.enable = false;
  };

  services.fail2ban = {
    enable = true;
    package = pkgs.fail2ban;
    packageFirewall = pkgs.nftables;
    banaction = "nftables-multiport";
    banaction-allports = "nftables-allport";
  };

  # Write systemd journald logs to RAM instead of disk
  services.journald.storage = "volatile";

  # Security
  # Enable AppArmor
  security.apparmor.enable = true;

  # Firewall config
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    interfaces."enp1s0" = {
      allowedTCPPorts = [
        # 22 # SSH
      ];
      allowedUDPPorts = [
      ];
    };
  };

  # Auto system upgrade
  system.autoUpgrade = {
    # enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
      "-L" # print build logs
    ];
    dates = "daily";
    operation = "boot";
  };

  # Binary Cache for Haskell.nix
  nix.settings.trusted-public-keys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.settings.substituters = [
    "https://cache.iog.io"
  ];

  # Auto optimize Nix store during rebuild
  nix.settings.auto-optimise-store = true;

  # Automatic Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

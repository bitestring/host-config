# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  userName = "bitestring";
  userDesc = "ƛ bitestring";
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Enable Nix experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Filesystem
  fileSystems =
    let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
      };
      aggregatedFonts = pkgs.buildEnv {
        name = "system-fonts";
        paths = config.fonts.packages;
        pathsToLink = [ "/share/fonts" ];
      };
    in
    {
      "/".options = [ "compress=zstd" "relatime" ];

      # Create an FHS mount to support flatpak host icons/fonts
      "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
      "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
    };

  # Swap
  zramSwap.enable = true;

  networking.hostName = "nixos-vm"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_IN/UTF-8"
  ];
  i18n.defaultLocale = "en_IN.UTF-8";
  i18n.extraLocaleSettings = {
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


  # Fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      fira-code
      fira-code-symbols
      hasklig
      source-code-pro
      cantarell-fonts
    ];
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable the GNOME Desktop Environment.
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    # displayManager.autoLogin.user = userName;

    # Configure keymap in X11
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Shell
  programs.fish.enable = true;
  environment.shells = with pkgs; [ fish ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userName} = {
    isNormalUser = true;
    description = userDesc;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    spice-vdagent
    wget
    curl
    git
    docker-compose
    bindfs
  ];

  virtualisation = {
    # https://nixos.wiki/wiki/Docker
    docker = {
      enable = true;
      storageDriver = "btrfs";
      enableOnBoot = true;
    };
    # https://nixos.wiki/wiki/Podman
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = false;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  security = {
    # Enable AppArmor
    apparmor.enable = true;
    apparmor.killUnconfinedConfinables = true;

    # Enable GNOME Keyring
    pam.services.gdm.enableGnomeKeyring = true;
  };

  # List services that you want to enable:
  services = {
    fstrim.enable = true;
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    tor = {
      enable = true;
      client.enable = true;
    };
    syncthing = {
      enable = true;
      user = userName;
      dataDir = "/home/${userName}/Syncthing-Shared";
      configDir = "/home/${userName}/.config/syncthing";
    };
    cockpit = {
      enable = true;
      port = 9090;
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [ 8384 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
    enable = true;
  };

  # Auto system update
  # system.autoUpgrade.enable = true;

  # Optimise Nix storage
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

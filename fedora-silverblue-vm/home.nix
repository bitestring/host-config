{ config, pkgs, ... }:
let
  userName = "bitestring";
  userEmail = "81476430+bitestring@users.noreply.github.com";
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = userName;
  home.homeDirectory = "/home/${userName}";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Fonts
  fonts.fontconfig.enable = true;

  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableFishIntegration = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userName = userName;
      userEmail = userEmail;
    };
    emacs = {
      enable = true;
      package = pkgs.emacs-gtk; # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
    };
  };

  # User packages
  home.packages = with pkgs; [
    # gnome extensions
    gnome-extension-manager
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.pano
    gnomeExtensions.vitals

    # fonts
    fira-code
    fira-code-symbols
    hasklig
    source-code-pro
    cantarell-fonts

    # apps
    tilix
    vscode
  ];
}

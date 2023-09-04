{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "bitestring";
  home.homeDirectory = "/home/bitestring";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Fonts
  fonts.fontconfig.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;  # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
  };

  # User packages
  home.packages = with pkgs; [
    gnome-extension-manager
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.pano
    gnomeExtensions.vitals

    tilix
    vscode
  ];
}

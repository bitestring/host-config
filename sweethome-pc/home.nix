{ config, pkgs, inputs, host, user, ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = user.name;
  home.homeDirectory = "/home/${user.name}";

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

  # User packages
  home.packages = with pkgs; [
    # gnome extensions
    gnomeExtensions.dash-to-dock

    # apps
  ];

  programs = {
    home-manager.enable = true;
    fish.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git.enable = true;
  };
}

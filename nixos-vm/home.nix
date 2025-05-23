{
  config,
  pkgs,
  inputs,
  host,
  user,
  ...
}:
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
    gnomeExtensions.system-monitor
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell

    # fonts
    fira-code
    fira-code-symbols
    hasklig
    source-code-pro

    # essential libraries and tools
    nixd # Nix language server
    lemminx # XML language server - Required by RedHat XML extension for VSCode

    # apps
    file
  ];

  programs = {
    home-manager.enable = true;
    fish.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userName = user.name;
      userEmail = user.email;
    };
    emacs = {
      enable = true;
      package = pkgs.emacs-gtk; # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
    };
    vscode =
      let
        vsx = inputs.nix-vscode-extensions.extensions.${pkgs.system};
      in
      {
        enable = true;
        package = pkgs.vscodium;
        profiles.default = {
          extensions = [
            vsx.open-vsx.ms-azuretools.vscode-docker # Todo: replace with the new generic Container Tools extension
            vsx.open-vsx.ms-vscode.makefile-tools
            vsx.open-vsx.llvm-vs-code-extensions.vscode-clangd
            vsx.open-vsx.ms-python.python
            vsx.open-vsx.redhat.vscode-xml
            vsx.open-vsx.redhat.vscode-yaml
            vsx.open-vsx.redhat.ansible
            vsx.open-vsx.vscode-icons-team.vscode-icons
            vsx.open-vsx.editorconfig.editorconfig
            vsx.open-vsx.esbenp.prettier-vscode
            vsx.open-vsx.eamodio.gitlens
            vsx.open-vsx.mkhl.direnv
            vsx.open-vsx.jnoortheen.nix-ide
            vsx.open-vsx.haskell.haskell
            vsx.open-vsx.justusadam.language-haskell
            vsx.open-vsx-release.rust-lang.rust-analyzer
          ];
          userSettings = {
            "extensions.autoUpdate" = false;
            "telemetry.telemetryLevel" = "off";
            "redhat.telemetry.enabled" = false;
            "workbench.enableExperiments" = false;
            "workbench.settings.enableNaturalLanguageSearch" = false;
            "workbench.colorTheme" = "Default Light Modern";
            "workbench.iconTheme" = "vscode-icons";
            "editor.fontSize" = 18;
            "editor.fontFamily" = "Fira Code";
            "editor.fontLigatures" = true;
            "terminal.integrated.fontSize" = 18;
            "window.titleBarStyle" = "custom";
            "window.autoDetectColorScheme" = true;
            "window.restoreWindows" = "none";
            "vsicons.dontShowNewVersionMessage" = true;
            "diffEditor.experimental.showMoves" = true;
            "diffEditor.ignoreTrimWhitespace" = false;
            "xml.codeLens.enabled" = true;
            "xml.server.preferBinary" = true;
            "xml.server.binary.path" = "${pkgs.lemminx.outPath}/bin/lemminx";
            "xml.server.binary.trustedHashes" = [
              (builtins.hashFile "sha256" "${pkgs.lemminx.outPath}/bin/lemminx")
            ];
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nixd";
            "haskell.manageHLS" = "PATH";
          };
        };
      };
  };

  dconf.settings = {
    # suspend power button action in GNOME
    "org/gnome/settings-daemon/plugins/power" = {
      "power-button-action" = "nothing";
    };
  };
}

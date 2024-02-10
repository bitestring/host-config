{ inputs, config, pkgs, ... }:
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

  # User packages
  home.packages = with pkgs; [
    # gnome extensions
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

    # other dependencies
    lemminx # XML language server - Required by RedHat XML extension for VSCode

    # apps
    tilix
    distrobox
  ];

  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
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
    vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        vscode-icons-team.vscode-icons
        editorconfig.editorconfig
        redhat.vscode-xml
        redhat.vscode-yaml
        esbenp.prettier-vscode
        eamodio.gitlens
        mkhl.direnv
        jnoortheen.nix-ide
        ms-vscode.makefile-tools
        haskell.haskell
        justusadam.language-haskell
        rust-lang.rust-analyzer
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "ansible";
          publisher = "redhat";
          version = "2.10.130";
          sha256 = "sha256-Ddjc70ZgJs+qKb6qwVrde4VJJ15/mwHu+9TTCJ4E+bY=";
        }
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
        "vsicons.dontShowNewVersionMessage" = true;
        "diffEditor.experimental.showMoves" = true;
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
}

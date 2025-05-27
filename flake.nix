{
  description = "Ansible playbooks, Nix Flakes and other scripts to provision my personal workstation and servers with apps and custom configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      dependencies = with pkgs; [
        # Nix deps
        nixd
        nixfmt-rfc-style

        # system deps
        glibcLocales

        # Python deps
        ansible
        ansible-lint
        ansible-language-server
      ];

    in
    {
      formatter.${system} = pkgs.nixfmt-rfc-style;
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = dependencies;
      };
    };
}

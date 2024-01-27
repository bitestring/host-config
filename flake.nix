{
  description = "Ansible playbooks, Nix Flakes and other scripts to provision my personal workstation and servers with apps and custom configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      dependencies = with pkgs; [
        # system deps
        glibcLocales

        # Python deps
        ansible
        ansible-lint
        ansible-language-server

        # Nix deps
        nixpkgs-fmt
      ];

    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = dependencies;
      };
    };
}

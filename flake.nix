{
  description = "Nix Flakes and Ansible Playbooks for provisioning my personal machines and VMs";

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
      # packages.${system}.default = pkgs.hello;

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = dependencies;
      };
    };
}

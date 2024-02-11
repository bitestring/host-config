{
  description = "My NixOS Flake";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org/"
    ];

    extra-substituters = [
      # nix community's cache server
      "https://nix-community.cachix.org"
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      host = {
        name = "nixos-vm";
        system = "x86_64-linux";
      };
      user = {
        name = "bitestring";
        description = "ƛ bitestring";
        email = "81476430+bitestring@users.noreply.github.com";
      };
      pkgs = import nixpkgs {
        system = host.system;
        config.allowUnfree = true;
      };
    in
    {
      formatter.${pkgs.system} = nixpkgs.legacyPackages.${pkgs.system}.nixpkgs-fmt;
      nixosConfigurations = {
        ${host.name} = nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = pkgs.system;
          specialArgs = {
            inherit inputs;
            inherit host;
            inherit user;
          };
          modules = [
            ./configuration.nix

            # make home-manager as a module of nixos
            # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user.name} = import ./home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit host;
                inherit user;
              };
            }
          ];
        };
      };
    };
}

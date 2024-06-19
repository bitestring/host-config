{
  description = "NixOS Flake for my personal workstation";

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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, ... }@inputs:
    let
      host = {
        name = "sweethome-pc";
        system = "x86_64-linux";
      };
      user = {
        name = "sweethome";
        description = "🏡 sweethome";
        email = "";
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

            lanzaboote.nixosModules.lanzaboote

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

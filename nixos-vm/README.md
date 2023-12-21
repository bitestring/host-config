# NixOS Configuration

Personal NixOS configuration for development.

## Update Flake

    $ sudo nix flake update

## Build the new configuration and  make  it  the  boot  default

    $ sudo nixos-rebuild boot

## Build and activate the new configuration

    $ sudo nixos-rebuild switch --flake '.#'

# NixOS Configuration

NixOS configuration for development.

# NixOS Makefile Guide

## Update Flakes and Rebuild

    $ make update

## Build the new configuration for next boot

    $ make boot

## Build and activate the new configuration

    $ make switch

## Run Garbage Collection

    $ make gc

## Repair Nix Store

    $ make repair

## List all system generations

    $ make ls

# NixOS Ephemeral Shells

**Examples**

    $ nix shell nixpkgs#pkg1

    $ nix shell nixpkgs#{pkg1,pkg2}


# Flatpak apps do not have correct fonts

Create a symbolic link to the system fonts directory inside home directory

    $ ln -s /usr/local/share/fonts/ ~/.local/share/fonts

Reference: https://wiki.nixos.org/wiki/Fonts

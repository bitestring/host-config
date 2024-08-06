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

# NixOS Ephemeral Shells

**Examples**

    $ nix shell nixpkgs#pkg1

    $ nix shell nixpkgs#{pkg1,pkg2}


# NixOS Configuration

Personal NixOS configuration for development.


## Step 1: Add NixOS-Unstable Channel

    $ sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos

## Step 2: Add Home-Manager Unstable Channel

    $ sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

## Step 3: Switch

    $ sudo nixos-rebuild switch --upgrade
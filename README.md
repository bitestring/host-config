Ansible playbooks, Nix Flakes and other scripts to provision my personal workstation and servers with apps and custom configuration.

# NixOS Makefile Guide

## Update Flakes and Rebuild

    $ make update

## Build and activate the new configuration

    $ make switch

## Run Garbage Collection

    $ make gc

# NixOS Ephemeral Shells

**Examples**

    $ nix shell nixpkgs#pkg1

    $ nix shell nixpkgs#{pkg1,pkg2}


# Ansible Guide

## Install Ansible Collections:

    $ ansible-galaxy collection install -r requirements.yml


## Run Playbook

    $ ansible-playbook <Playbook.yml>

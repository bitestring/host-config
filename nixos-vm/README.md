# NixOS Configuration

NixOS configuration for development.

Carefully select required configuration from existing `/etc/nixos` and then merge the changes to this directory. Then delete `/etc/nixos` and symlink this directory to `/etc/nixos`.

# NixOS Makefile Guide

## Update Flakes and Rebuild

```
make update
```

## Build the new configuration for next boot

```
make boot
```

## Build and activate the new configuration

```
make switch
```

## Run Garbage Collection

```
make gc
```

## Repair Nix Store

```
make repair
```

## List all system generations

```
make ls
```

# NixOS Ephemeral Shells

**Examples**

```
nix shell nixpkgs#pkg1
```

```
nix shell nixpkgs#{pkg1,pkg2}
```

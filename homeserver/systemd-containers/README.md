This directory contains Podman based rootless systemd containers

## Activating the containers

Symlink this directory to `~/.config/containers/systemd`.

    $ ln -s <ABSOLUTE_PATH_TO_CURRENT_DIR> ~/.config/containers/systemd

Once symlinked, all Podman resources declared in this directory are automatically started by systemd according to the resource's configuration.

## User ID mapping

> Note: `root` user inside the container is always mapped to host user who started the container (Ex. `1000`).

Since Podman containers run in rootless mode, the user IDs inside the container is mapped to the host using the formula `<from_subuid_in_host> + <userid_inside_the_container> - 1`.

For example, if `/etc/subuid` has following subuid configured for the user `sweethome` on the host

```
$ cat /etc/subuid
sweethome:524288:65536
```

then user `33` (www-data) inside a container would be mapped to

```
524288 + 33 - 1 = 524320
```

on the host.

Reference: https://opensource.com/article/19/2/how-does-rootless-podman-work

## Change ownership of files after migration

If user ID mapping is changed due to OS reinstallation, then compute the new UID and change ownership using `chown` as follows

```
sudo chown --recursive --from=CURRENT_OWNER:CURRENT_GROUP NEW_OWNER:NEW_GROUP  *
```

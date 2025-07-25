> This directory contains Podman based rootless systemd containers.

## Activating the containers

Each service has instructions to activate them in their respective README.md file.

## Data Volumes

It is assumed that the data would be stored at user's home directory and follows following scheme

`$HOME/data/volumes/<POD>/<CONTAINER>/<data|config|...>`

> Note: Mount your disk at `$HOME/data/` to ensure all user data is persisted.

## User ID mapping

> Note: `root` user inside the container is always mapped to host user who started the container (Ex. `1000`).

Since Podman containers run in rootless mode, the user IDs inside the container is mapped to the host using the formula `<from_subuid_in_host> + <userid_inside_the_container> - 1`.

For example, if `/etc/subuid` has following subuid configured for the user `sweethome` on the host

```
$ cat /etc/subuid
sweethome:524288:65536
```

then user `33` (www-data) inside a container would be mapped to

`524288 + 33 - 1 = 524320`

on the host.

Reference: https://opensource.com/article/19/2/how-does-rootless-podman-work

### Editing files from the host

Since User ID is different for files created by the container in a volume, `podman unshare` can be used to edit them without requiring `sudo`.

```
$ podman unshare nano example.conf
```

This works because the subuid range belongs to the user on the host.

## Change ownership of files after migration

If user ID mapping is changed due to OS reinstallation, then compute the new host UID for the files created by the container and change ownership using `chown` as follows

```
sudo chown --recursive --from=CURRENT_OWNER:CURRENT_GROUP NEW_OWNER:NEW_GROUP  *
```

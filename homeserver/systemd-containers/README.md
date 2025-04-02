This directory contains Podman based non-root systemd containers

**Symlink this directory to ~/.config/containers/systemd**

    $ ln -s <ABSOLUTE_PATH_TO_CURRENT_DIR> ~/.config/containers/systemd

Once symlinked, all Podman resources declared in this directory are automatically started by systemd as per the configuration of the resource.

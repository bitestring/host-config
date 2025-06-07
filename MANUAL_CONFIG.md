
# Manual configurations

> Commands described here for Fedora/RHEL based hosts

## TRIM on SSDs

Ensure TRIM is enabled for SSDs in filesystems and LUKS/LVM layers. To confirm if TRIM already works, run

```
$ sudo fstrim --all --verbose

/boot/efi: 579.5 MiB (607686656 bytes) trimmed on /dev/nvme0n1p1
/boot: 591.4 MiB (620167168 bytes) trimmed on /dev/nvme0n1p2
/: 321.9 GiB (345603985408 bytes) trimmed on /dev/mapper/luks-d266ce37-25ec-4abf-bfbd-993d2d40666a
```

It should have trimmed all partitions. If not, TRIM might not be enabled at LUKS layer. To enable TRIM in LUKS, add **discard** option to LUKS partition.

```
$ sudo cryptsetup --allow-discards --persistent refresh <luks-partition-id>
```

For example

```
$ sudo cryptsetup --allow-discards --persistent refresh luks-d266ce37-25ec-4abf-bfbd-993d2d40666a
```

This can be verified by checking `/etc/crypttab`

```
$ sudo cat /etc/crypttab

luks-d266ce37-25ec-4abf-bfbd-993d2d40666a UUID=d266ce37-25ec-4abf-bfbd-993d2d40666a none discard
```

Then regenerate **initramfs**.

```
$ sudo dracut --regenerate-all --force
```

### For Atomic variants

```
$ rpm-ostree kargs --append-if-missing=rd.luks.options=discard
```

Once TRIM is enabled, check the mount options

```
$ mount | grep discard

/dev/mapper/luks-d266ce37-25ec-4abf-bfbd-993d2d40666a on / type btrfs (rw,relatime,seclabel,compress=zstd:3,ssd,discard=async,space_cache=v2,subvolid=262,subvol=/root)
/dev/mapper/luks-d266ce37-25ec-4abf-bfbd-993d2d40666a on /home type btrfs (rw,relatime,seclabel,compress=zstd:3,ssd,discard=async,space_cache=v2,subvolid=257,subvol=/home)
```

## BTRFS Compression

Enable filesystem level compression to increase SSD life. Edit `/etc/fstab` to add following mount options to btrfs volumes

```
compress=zstd:3
```

For example, `/etc/fstab` should look like

```
UUID=6D80-55F8          /boot/efi               vfat    umask=0077,shortname=winnt 0 2
UUID=cc4bb288-530b-4688-bcab-7ba12a22cce9 /boot                   ext4    defaults        1 2
UUID=ed2ff779-ebbb-4fb0-816b-4e6035eedbae /                       btrfs   subvol=root,compress=zstd:3,x-systemd.device-timeout=0 0 0
UUID=ed2ff779-ebbb-4fb0-816b-4e6035eedbae /home                   btrfs   subvol=home,compress=zstd:3,x-systemd.device-timeout=0 0 0
```

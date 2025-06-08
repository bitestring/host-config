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

Verify mount options

```
$ mount | grep btrfs

/dev/mapper/luks-d266ce37-25ec-4abf-bfbd-993d2d40666a on / type btrfs (rw,relatime,seclabel,compress=zstd:3,ssd,discard=async,space_cache=v2,subvolid=262,subvol=/root)
/dev/mapper/luks-d266ce37-25ec-4abf-bfbd-993d2d40666a on /home type btrfs (rw,relatime,seclabel,compress=zstd:3,ssd,discard=async,space_cache=v2,subvolid=257,subvol=/home)
```

### Test BTRFS compression

To check if BTRFS compression is working, use `compsize` on a directory to get compression ratio data.

```
$ sudo compsize ~/

Processed 681218 files, 655020 regular extents (952350 refs), 334108 inline, 1268900 fragments.
Type       Perc     Disk Usage   Uncompressed Referenced
TOTAL       94%      149G         158G         105G
none       100%      144G         144G          80G
zstd        37%      5.1G          13G          24G
prealloc   100%      193M         193M         193M

```

## Review firewall config

https://firewalld.org/

Manually review the firewall configuration to ensure it is secure.

Review if network interfaces are correctly attached to appropriate zones. Block all services and ports on **public** zone and allow only required services and ports on **home** zone.

On **firewalld**, current configuration can be shown with

```
$ sudo firewall-cmd --list-all-zones
```

```
$ sudo firewall-cmd --list-services --zone=public
```

```
$ sudo firewall-cmd --list-ports --zone=public
```

```
$ sudo firewall-cmd --get-default-zone
```

### Test firewall config

To verify if firewall is correctly configured, manually do a port scan on target host using `nmap`.

For example,

```
$ sudo nmap -sS sweethome-server
$ sudo nmap -sS sweethome-server.lan
$ sudo nmap -sS 192.168.1.100
$ sudo nmap -sS -6 <Public_IP_V6_Addr>
```

should list open ports.

## Review Fail2Ban

https://github.com/fail2ban/fail2ban

Fail2Ban scans log files like /var/log/auth.log and bans IP addresses conducting too many failed login attempts.

Check the jail status

```
$ sudo fail2ban-client status

Status
|- Number of jail:	2
`- Jail list:	pam-generic, sshd
```

### Test Fail2Ban config

To check if Fail2Ban works, login into Cockpit or SSH with incorrect credentials. After a few attempts, your IP address will be blocked from accessing the target host.

Banned IP addresses can be checked using

```
$ sudo fail2ban-client banned
```

To unban after the test, run

```
$ sudo fail2ban-client unban <IP_Addr>
```

## Tailscale and rp_filter rules

If you are using Tailscale exit-nodes feature, check if `tailscale` complains about strict `rp_filter` rules

```
$ sudo tailscale status

...

# Health check:
#     - Exit node misconfiguration: The following issues on your machine will likely make usage of exit nodes impossible: [interface "tailscale0" has strict reverse-path filtering enabled], please set rp_filter=2 instead of rp_filter=1; see https://github.com/tailscale/tailscale/issues/3310
```

If there's health check warning about _rp_filter_, create a override config to loosen the strict default configuration

Create a file

`/etc/sysctl.d/90-override.conf`

with the following contents

```
net.ipv4.conf.tailscale0.rp_filter = 2
net.ipv4.conf.virbr0.rp_filter = 2
```

Change the interface names as per `tailscale status` report. Reboot the host to apply the new config.

You can check the current config by querying `sysctl`

```
$ sudo sysctl -a | grep rp_filter
```

## sudo does not ask for password

If `sudo` command does not ask for user's password, the user might have been configured with _NOPASSWD_ option during system installation.

Review any config under `/etc/sudoers.d/` for following line

```
<username> ALL=(ALL) NOPASSWD:ALL
```

and comment it. This is important for a secure configuration of the host.

## Replace disk based swap with ZRAM

https://www.privacyguides.org/en/os/linux-overview/#swap

Disable swap file or partition on `/etc/fstab`.

For example,

```
$ cat /etc/fstab

UUID=bfa456ee-2843-4930-b93f-ce49976479cf  / ext4    defaults,noatime 0 0
UUID=6401-5E60  /boot vfat    defaults,noatime 0 0
#/swapfile      none    swap    defaults        0       0
```

Use `zram` if available on your distribution.

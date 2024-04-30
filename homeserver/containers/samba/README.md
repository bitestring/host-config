# Samba

## Step 1: Create secrets using `pass` to store Samba credentials

Reference: https://opensource.com/article/22/1/manage-passwords-linux-terminal

```
gpg --generate-key

pass init <CERTIFICATE_USERNAME>

pass add SAMBA_USERNAME

pass add SAMBA_PASSWORD
```

## Step 2: Create .env file

Create a .env file which points to the host directory to be shared over Samba

```
nano .env
```

**Example .env file:**
```
HOST_DIR=<EXAMPLE>
MOUNT_POINT=/mnt/<EXAMPLE>
```

## Step 3: Create Samba config

Create a volume for Samba configuration files

```
mkdir --parents ./volumes/config/
```

```
nano ./volumes/config/smb.conf
```

**Example config:**

```
# See smb.conf.example for a more detailed config file or
# read the smb.conf manpage.
# Run 'testparm' to verify the config is correct after
# you modified it.
#
# Note:
# SMB1 is disabled by default. This means clients without support for SMB2 or
# SMB3 are no longer able to connect to smbd (by default).

[global]
    workgroup = SAMBA
    security = user
    passdb backend = tdbsam
    unix extensions = yes
    server min protocol = SMB3
    server signing = mandatory
    server smb encrypt = required
    socket options = IPTOS_LOWDELAY TCP_NODELAY

[share-name]
    comment = share-name
    path = /mnt/<EXAMPLE>/
    writeable = yes
    browseable = yes
    create mask = 0640
    directory mask = 0755
    write list = <USERNAME>
```

## Step 3: Launch Samba

```
./up.sh
```


# Mounting Samba Share

To auto-mount a Samba share on the local network, add the following entry to `/etc/fstab`


```
//<HOSTNAME>.lan/<SHARENAME> /mnt/samba/<SHARENAME> cifs nofail,_netdev,x-systemd.automount,uid=<USERNAME>,gid=<USERNAME>,credentials=/var/home/<USERNAME>/.smbcred 0 0
```

Be sure to create a Samba credential file in `/var/home/<USERNAME>/.smbcred`

Example credential file

```
username=<USERNAME>
password=<PASSWORD>
domain=SAMBA
```

Make sure the file is readable only by `root`

```
sudo chown root:root ~/.smbcred
sudo chmod u=rw,g=,o= ~/.smbcred
```

Now reload systemd daemon and mount

```
sudo systemctl daemon-reload
sudo mount -a -t cifs
```

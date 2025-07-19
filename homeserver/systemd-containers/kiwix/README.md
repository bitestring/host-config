# Kiwix

[Kiwix](https://kiwix.org/) is an open-source software that allows you to have the whole Wikipedia at your fingertips! You can browse the content of Wikipedia, TED talks, Stack Exchange, and many other resources without an internet connection.

# Prerequisites

-   [Podman](https://podman.io/)
-   [Fail2Ban](https://github.com/fail2ban/fail2ban)

# Run Kiwix

## Step 1: Generate self-signed TLS certificate

```
openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -days 36500 -noenc -keyout ./caddy/cert.key -out ./caddy/cert.crt
```

Make sure to enter your server domain name during the `Common Name (e.g. server FQDN or YOUR name) []` prompt.

**Reference:** https://stackoverflow.com/questions/10175812/how-can-i-generate-a-self-signed-ssl-certificate-using-openssl#comment57700926_10176685

## Step 2: Confirm data volume location

Kiwix container assumes data is stored in `~/data/volumes/kiwix/kiwix/data/`. If data already exists at this location, it would be automatically used. Otherwise this directory will be created as part of `make install` step.

## Step 3: Install Kiwix

Install Kiwix units and sockets in user's systemd directories using

```
make install
```

## Step 4: Download .zim files

`kiwix-serve` requires atleast one `.zim` file in the data directory to start. So download some `.zim` files from https://library.kiwix.org/

**Example:**

```
cd ~/data/volumes/kiwix/kiwix/data/

curl --progress-bar -O --location https://download.kiwix.org/zim/other/zimgit-medicine_en_2024-08.zim
```

## Step 5: Start Kiwix

```
make start
```

## Step 6: Open firewall

To access Kiwix in your network, open the configured port on firewall.

Example using `firewall-cmd`:

```
sudo firewall-cmd --zone=home --add-port={7003/tcp,7003/udp} --permanent
sudo firewall-cmd --reload
```

# Check service health

To check if all Kiwix services and sockets are up and running, run

```
make list
```

To check the detailed status and logs of each Kiwix unit and socket, run

```
make status
```

# Check Fail2Ban configuration

```
sudo fail2ban-client status kiwix
```

To check if the filter is working, try

```
fail2ban-regex systemd-journal[journalflags=1] kiwix -r --print-all-matched
```

This would print matching logs, only if there are failed login attempts or logs match the filter.

# Add new .zim files

New `.zim` files can be downloaded to the data directory as explained in [Step 4](#step-4-download-zim-files). However a restart of the Kiwix Pod is required for `kiwix-serve` to recognize new files.

# Uninstall

Remove Kiwix units and sockets from user's systemd directories using

```
make stop
make uninstall
```

# References

https://github.com/kiwix/kiwix-tools/tree/main/docker/server
https://wiki.openzim.org/wiki/Main_Page
https://library.kiwix.org/
https://kiwix.org/

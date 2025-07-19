# Nextcloud

[Nextcloud](https://nextcloud.com/) is a suite of client-server software for creating and using file hosting services.

# Prerequisites

-   [Podman](https://podman.io/)
-   [Fail2Ban](https://github.com/fail2ban/fail2ban)
-   [OpenSSL](https://www.openssl.org/)

# Run Nextcloud

## Step 1: Create .env file

Create a `.env` file based on `.env.template` and configure ports, domains, timezone etc.

```
cp .env.template .env
```

## Step 2: Confirm data volume location

Nextcloud container assumes data is stored in `~/data/volumes/nextcloud/nextcloud/data/`. If data already exists at this location, it would be automatically used. Otherwise this directory will be created as part of `make install` step.

## Step 3: Install Nextcloud

To generate self-signed certificate, configure fail2ban and install systemd user units and sockets, run

```
make install
```

## Step 4: Start Nextcloud

```
make start
```

## Step 5: Open firewall

To access Nextcloud in your network, open the configured port on firewall.

Example using `firewall-cmd`:

```
sudo firewall-cmd --zone=home --add-port={7000/tcp,7000/udp} --permanent
sudo firewall-cmd --reload
```

# Check service health

To check if all services and sockets are up and running, run

```
make list
```

To check the detailed status and logs of each systemd unit and socket, run

```
make status
```

# Check Nextcloud configuration

To check if Nextcloud is correctly installed and configured, login to Nextcloud and check **_Administration settings -> Administration -> Overview_**. This page will report critical errors and warnings.

# Check Fail2Ban configuration

```
sudo fail2ban-client status nextcloud
```

To check if the filter is working, try

```
fail2ban-regex systemd-journal[journalflags=1] nextcloud -r --print-all-matched
```

This would print matching logs, only if there are failed login attempts or logs match the filter.

# Rotate TLS Certificate

To generate a new self-signed TLS certificate, delete the existing certificate files from `./caddy` directory.

```
rm ./caddy/cert.key ./caddy/cert.crt
make cert
make stop && make start
```

# Nextcloud maintenance

Occasionally Nextcloud maintenance jobs need to be executed manually. For example, to create indexes. Use following command to achieve the same.

```
make maintenance
```

# Reindex all files

```
make scan
```

# Uninstall Nextcloud

To remove fail2ban configuration and systemd user units and sockets, run

```
make stop
make uninstall
```

# References

https://github.com/nextcloud/docker/tree/master/.examples/docker-compose/with-nginx-proxy/postgres/apache

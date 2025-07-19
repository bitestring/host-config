# Nextcloud

[Nextcloud](https://nextcloud.com/) is a suite of client-server software for creating and using file hosting services.

# Prerequisites

-   [Podman](https://podman.io/)
-   [Fail2Ban](https://github.com/fail2ban/fail2ban)

# Run Nextcloud

## Step 1: Generate self-signed TLS certificate

https://www.linode.com/docs/guides/create-a-self-signed-tls-certificate/

```
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out ./caddy/cert.pem -keyout ./caddy/cert.key
```

Make sure to enter your server domain name during the `Common Name (e.g. server FQDN or YOUR name) []` prompt.

## Step 2: Create .env file

Create a `.env` file based on `.env.template` and configure ports, domains, timezone etc.

```
cp .env.template .env
```

## Step 3: Confirm data volume location

Nextcloud container assumes data is stored in `~/data/volumes/nextcloud/nextcloud/data/`. If data already exists at this location, it would be automatically used. Otherwise this directory will be created as part of `make install` step.

## Step 4: Install Nextcloud

Install Nextcloud units and sockets in user's systemd directories using

```
make install
```

## Step 5: Start Nextcloud

```
make start
```

## Step 6: Open firewall

To access Nextcloud in your network, open the configured port on firewall.

Example using `firewall-cmd`:

```
sudo firewall-cmd --zone=home --add-port={7000/tcp,7000/udp} --permanent
sudo firewall-cmd --reload
```

# Check service health

To check if all Nextcloud services and sockets are up and running, run

```
make list
```

To check the detailed status and logs of each Nextcloud unit and socket, run

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

# Nextcloud maintenance

Occasionally Nextcloud maintenance jobs need to be executed manually. For example, to create indexes. Use following command to achieve the same.

```
make maintenance
```

# Reindex all files

```
make scan
```

# Uninstall

Remove Nextcloud units and sockets from user's systemd directories using

```
make stop
make uninstall
```

# References

https://github.com/nextcloud/docker/tree/master/.examples/docker-compose/with-nginx-proxy/postgres/apache

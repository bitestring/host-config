# DokuWiki

[DokuWiki](https://www.dokuwiki.org/) is a simple to use and highly versatile Open Source wiki software that doesn't require a database.

# Prerequisites

-   [Podman](https://podman.io/)
-   [Fail2Ban](https://github.com/fail2ban/fail2ban)
-   [OpenSSL](https://www.openssl.org/)

# Run DokuWiki

## Step 1: Create .env file

Create a `.env` file based on `.env.template` and configure ports, domains, timezone etc.

```
cp .env.template .env
```

## Step 2: Confirm data volume location

DokuWiki container assumes data is stored in `~/data/volumes/dokuwiki/dokuwiki/data/`. If data already exists at this location, it would be automatically used. Otherwise this directory will be created as part of `make install` step.

## Step 3: Install DokuWiki

To generate self-signed certificate, configure fail2ban and install systemd user units and sockets, run

```
make install
```

## Step 4: Start DokuWiki

```
make start
```

## Step 5: Open firewall

To access DokuWiki in your network, open the configured port on firewall.

Example using `firewall-cmd`:

```
sudo firewall-cmd --zone=home --add-port={7001/tcp,7001/udp} --permanent
sudo firewall-cmd --reload
```

## Step 6: Configure DokuWiki installation

Once the service is up, goto https://SERVER:7001/install.php and configure Users and ACLs.

Reference: https://www.dokuwiki.org/installer

# Check service health

To check if all services and sockets are up and running, run

```
make list
```

To check the detailed status and logs of each systemd unit and socket, run

```
make status
```

# Check Fail2Ban configuration

```
sudo fail2ban-client status dokuwiki
```

To check if the filter is working, try

```
fail2ban-regex systemd-journal[journalflags=1] dokuwiki -r --print-all-matched
```

This would print matching logs, only if there are failed login attempts or logs match the filter.

# Rotate TLS Certificate

To generate a new self-signed TLS certificate, delete the existing certificate files from `./caddy` directory.

```
rm ./caddy/cert.key ./caddy/cert.crt
make cert
make stop && make start
```

# Uninstall DokuWiki

To remove fail2ban configuration and systemd user units and sockets, run

```
make stop
make uninstall
```

# References

https://github.com/dokuwiki/docker

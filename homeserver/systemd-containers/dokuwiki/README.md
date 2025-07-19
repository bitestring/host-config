# DokuWiki

[DokuWiki](https://www.dokuwiki.org/) is a simple to use and highly versatile Open Source wiki software that doesn't require a database.

# Prerequisites

-   [Podman](https://podman.io/)
-   [Fail2Ban](https://github.com/fail2ban/fail2ban)

# Run DokuWiki

## Step 1: Generate self-signed TLS certificate

```
openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -days 36500 -noenc -keyout ./caddy/cert.key -out ./caddy/cert.crt
```

Make sure to enter your server domain name during the `Common Name (e.g. server FQDN or YOUR name) []` prompt.

**Reference:** https://stackoverflow.com/questions/10175812/how-can-i-generate-a-self-signed-ssl-certificate-using-openssl#comment57700926_10176685

## Step 2: Create .env file

Create a `.env` file based on `.env.template` and configure ports, domains, timezone etc.

```
cp .env.template .env
```

## Step 3: Confirm data volume location

DokuWiki container assumes data is stored in `~/data/volumes/dokuwiki/dokuwiki/data/`. If data already exists at this location, it would be automatically used. Otherwise this directory will be created as part of `make install` step.

## Step 4: Install DokuWiki

Install DokuWiki units and sockets in user's systemd directories using

```
make install
```

## Step 5: Start DokuWiki

```
make start
```

## Step 6: Open firewall

To access DokuWiki in your network, open the configured port on firewall.

Example using `firewall-cmd`:

```
sudo firewall-cmd --zone=home --add-port={7001/tcp,7001/udp} --permanent
sudo firewall-cmd --reload
```

## Step 7: Configure DokuWiki Installation

Once the service is up, goto https://SERVER:7001/install.php and configure Users and ACLs.

Reference: https://www.dokuwiki.org/installer

# Check service health

To check if all DokuWiki services and sockets are up and running, run

```
make list
```

To check the detailed status and logs of each DokuWiki unit and socket, run

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

# Uninstall

Remove DokuWiki units and sockets from user's systemd directories using

```
make stop
make uninstall
```

# References

https://github.com/dokuwiki/docker

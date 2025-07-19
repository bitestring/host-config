# Paperless-ngx

[Paperless-ngx](https://docs.paperless-ngx.com/) is a community-supported open-source document management system that transforms your physical documents into a searchable online archive so you can keep, well, less paper.

# Prerequisites

-   [Podman](https://podman.io/)
-   [Fail2Ban](https://github.com/fail2ban/fail2ban)

# Run Paperless-ngx

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

Paperless-ngx container assumes data is stored under `~/data/volumes/paperless-ngx/*`. If data already exists at this location, it would be automatically used. Otherwise this directory will be created as part of `make install` step.

## Step 4: Install Paperless-ngx

Install Paperless-ngx units and sockets in user's systemd directories using

```
make install
```

## Step 5: Start Paperless-ngx

```
make start
```

## Step 6: Open firewall

To access Paperless-ngx in your network, open the configured port on firewall.

Example using `firewall-cmd`:

```
sudo firewall-cmd --zone=home --add-port={7002/tcp,7002/udp} --permanent
sudo firewall-cmd --reload
```

# Check service health

To check if all Paperless-ngx services and sockets are up and running, run

```
make list
```

To check the detailed status and logs of each Paperless-ngx unit and socket, run

```
make status
```

# Check Fail2Ban configuration

```
sudo fail2ban-client status paperless-ngx
```

To check if the filter is working, try

```
fail2ban-regex systemd-journal[journalflags=1] paperless-ngx -r --print-all-matched
```

This would print matching logs, only if there are failed login attempts or logs match the filter.

# Uninstall

Remove Paperless-ngx units and sockets from user's systemd directories using

```
make stop
make uninstall
```

# References

https://github.com/paperless-ngx/paperless-ngx
https://docs.paperless-ngx.com/setup/

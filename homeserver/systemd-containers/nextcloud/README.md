# Nextcloud

Reference: https://github.com/nextcloud/docker/tree/master/.examples/docker-compose/with-nginx-proxy/postgres/apache

# Run Nextcloud

## Step 1: Generate self-signed TLS certificate

https://www.linode.com/docs/guides/create-a-self-signed-tls-certificate/

```
openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out ./caddy/cert.pem -keyout ./caddy/cert.key
```

Make sure to enter your server domain name during the `Common Name (e.g. server FQDN or YOUR name) []` prompt.

## Step 2: Create a volume to store data

```
mkdir --parents ~/data/volumes/nextcloud/nextcloud/data/
```

## Step 3: Create .env file

Create a .env file which provides hostname and port on which Nextcloud is exposed.

```
cp .env.template .env
```

## Step 4: Install Nextcloud

Install Nextcloud units and sockets in user's systemd directories using

```
make install
```

## Step 5: Run Nextcloud

```
make start
```

## Step 6: Open firewall

To access Nextcloud in your network, open the configured port on firewall.

_Example using firewall-cmd:_

```
sudo firewall-cmd --zone=home --add-port={7443/tcp,7443/udp} --permanent
sudo firewall-cmd --reload
```

# Test Nextcloud configuration

To test if Nextcloud is correctly installed and configured, login to Nextcloud and check **_Administration settings -> Administration -> Overview_**. This page will report critical errors and warnings.

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

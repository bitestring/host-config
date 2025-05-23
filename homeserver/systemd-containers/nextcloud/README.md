# Nextcloud

Reference: https://github.com/nextcloud/docker/tree/master/.examples/docker-compose/with-nginx-proxy/postgres/apache

## Step 1: Generate self-signed TLS certificate

https://www.linode.com/docs/guides/create-a-self-signed-tls-certificate/

    openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out ./caddy/cert.pem -keyout ./caddy/cert.key

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

## Step 4: Launch Nextcloud

```
make start
```

# Nextcloud Maintanence

Sometimes Nextcloud maintanence jobs need to be executed manually. For example, to create indexes. Use following command to achieve the same.

```
make maintenance
```

# Reindex all files

```
make scan
```

# Change ownership of files after migration

```
sudo chown --recursive --from=CURRENT_OWNER:CURRENT_GROUP NEW_OWNER:NEW_GROUP  *
```

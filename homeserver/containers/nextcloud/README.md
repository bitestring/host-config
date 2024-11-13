# Nextcloud

Reference: https://github.com/nextcloud/docker/tree/master/.examples/docker-compose/with-nginx-proxy/postgres/apache

## Step 1: Generate self-signed SSL certificate

https://www.linode.com/docs/guides/create-a-self-signed-tls-certificate/

    openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out ./nginx/cert.pem -keyout ./nginx/cert.key

## Step 2: Create a volume to store data

```
mkdir --parents ./volumes/data/
```

## Step 3: Create .env file

Create a .env file which provides hostname and port on which Nextcloud is exposed.

```
nano .env
```

**Example .env file:**

```
HOST=<HOSTNAME>
PORT=<PORT>
```

## Step 4: Launch Nextcloud

```
make up
```

# Nextcloud Maintanence

Sometimes Nextcloud maintanence jobs need to be executed manually. For example, to create indexes. Use following command to achieve the same.

    make maintenance

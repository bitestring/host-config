# Nextcloud

**Reference:**
https://github.com/nextcloud/docker/tree/master/.examples/docker-compose/with-nginx-proxy/postgres/apache

## Step 1: Generate self-signed TLS certificate

```
openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -days 36500 -noenc -keyout ./nginx/cert.key -out ./nginx/cert.crt
```

**Reference:**
https://stackoverflow.com/questions/10175812/how-can-i-generate-a-self-signed-ssl-certificate-using-openssl#comment57700926_10176685

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

```
make maintenance
```

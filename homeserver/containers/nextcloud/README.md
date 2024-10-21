https://github.com/nextcloud/docker/tree/master/.examples/docker-compose/with-nginx-proxy/postgres/apache

# Generate self-signed SSL certificate

https://www.linode.com/docs/guides/create-a-self-signed-tls-certificate/

    openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out cert.pem -keyout cert.key

# Nextcloud Maintanence

Sometimes Nextcloud maintanence jobs need to be executed manually. For example, to create indexes. Use following command to achieve the same.

    make maintenance

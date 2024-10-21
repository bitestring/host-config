https://github.com/nextcloud/docker/tree/master/.examples/docker-compose/with-nginx-proxy/postgres/apache

# Generate self-signed SSL certificate
https://daurnimator.github.io/post/2015/04/06/howto-generate-a-self-signed-ssl-cert-in-one/

    openssl req -newkey 2048 -keyout cert.key -nodes -x509 -out cert.pem -batch

The meaning of the options:

    -newkey 2048: generate a new 2048 bit RSA private key instead of using an existing one

    -keyout cert.key: save the rsa key in cert.key

    -nodes: don’t encrypt the private key

    -x509: generate an actual cert (rather than a certificate request)

    -out cert.epm: save the certificate as cert.pem

    -batch: don’t ask for the various SSL cert metadata fields


# Nextcloud Maintanence

Sometimes Nextcloud maintanence jobs need to be executed manually. For example, to create indexes. Use following command to achieve the same.


    sudo docker exec --user www-data --interactive --tty nextcloud-nextcloud-1 php occ db:add-missing-indices

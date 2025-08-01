echo "Note: Delete existing certificates before running this script!"
echo "Generating certificates. Please wait..."
mkdir --parents ./config/wazuh_indexer_ssl_certs/
podman run \
    --volume ./config/wazuh_indexer_ssl_certs/:/certificates/:z \
    --volume ./config/certs.yml:/config/certs.yml:z \
    wazuh/wazuh-certs-generator:0.0.2
# Change permissions and modes, so other Wazuh containers can still read the certificates in rootless mode.
sudo chown --recursive 1000:1000 ./config/wazuh_indexer_ssl_certs/*
chmod --recursive ugo=r ./config/wazuh_indexer_ssl_certs/*

usr=$(pass show SAMBA_USERNAME)
pswd=$(pass show SAMBA_PASSWORD)
SAMBA_USERNAME=$usr SAMBA_PASSWORD=$pswd sudo -E docker compose up --build --detach

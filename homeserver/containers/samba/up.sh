usr=$(secret-tool lookup username SAMBA_CREDS)
pswd=$(secret-tool lookup password SAMBA_CREDS)
SAMBA_USERNAME=$usr SAMBA_PASSWORD=$pswd sudo -E docker compose up --build --detach

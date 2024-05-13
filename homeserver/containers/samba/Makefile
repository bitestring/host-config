USR := $(pass show SAMBA_USERNAME)
PSWD := $(pass show SAMBA_PASSWORD)

.PHONY: up
up:
	SAMBA_USERNAME=$(USR) SAMBA_PASSWORD=$(PSWD) sudo -E docker compose up --build --detach

.PHONY: down
down:
	sudo docker compose down

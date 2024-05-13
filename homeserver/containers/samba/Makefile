USR := $(shell pass show SAMBA_USERNAME)
PSWD := $(shell pass show SAMBA_PASSWORD)

.PHONY: up
up:
	SAMBA_USERNAME="$(USR)" SAMBA_PASSWORD="$(PSWD)" sudo -E docker compose up --build --detach

.PHONY: down
down:
	sudo docker compose down

.PHONY: update
update:
	sudo docker compose down --rmi all
	sudo docker compose build --pull --no-cache
	SAMBA_USERNAME="$(USR)" SAMBA_PASSWORD="$(PSWD)" sudo -E docker compose up --detach

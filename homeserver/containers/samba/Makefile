.EXPORT_ALL_VARIABLES:
SAMBA_USERNAME := $(shell pass show SAMBA_USERNAME)
SAMBA_PASSWORD := $(shell pass show SAMBA_PASSWORD)

.PHONY: up
up:
	sudo -E docker compose up --build --detach

.PHONY: down
down:
	sudo -E docker compose down

.PHONY: update
update:
	sudo -E docker compose down --rmi all
	sudo -E docker compose build --pull --no-cache
	sudo -E docker compose up --detach

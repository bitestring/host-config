.PHONY: up
up:
	sudo docker compose up --detach

.PHONY: down
down:
	sudo docker compose down

.PHONY: update
update:
	sudo docker compose pull
	sudo docker compose up --detach

.PHONY: maintenance
maintenance:
	sudo docker exec --user www-data --interactive --tty nextcloud-nextcloud-1 php occ db:add-missing-indices
	sudo docker exec --user www-data --interactive --tty nextcloud-nextcloud-1 php occ maintenance:repair --include-expensive

.PHONY: up
up:
	systemctl --user start nextcloud-pod

.PHONY: down
down:
	systemctl --user stop nextcloud-pod

.PHONY: update
update:
	podman auto-update

.PHONY: maintenance
maintenance:
	podman exec --user www-data --interactive --tty systemd-nextcloud php occ db:add-missing-indices
	podman exec --user www-data --interactive --tty systemd-nextcloud php occ maintenance:repair --include-expensive

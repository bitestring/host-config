.PHONY: start
start:
	systemctl --user start nextcloud-pod

.PHONY: stop
stop:
	systemctl --user stop nextcloud-pod

.PHONY: update
update:
	podman auto-update

.PHONY: maintenance
maintenance:
	podman exec --user www-data --interactive --tty systemd-nextcloud php occ db:add-missing-indices
	podman exec --user www-data --interactive --tty systemd-nextcloud php occ maintenance:repair --include-expensive

.PHONY: scan
scan:
	podman exec --user www-data --interactive --tty systemd-nextcloud php occ files:scan --all

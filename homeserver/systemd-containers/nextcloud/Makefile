.PHONY: prerequisite
prerequisite:
	@test -s ./.env || { echo ".env file does not exist! Refer README.md for more info. Exiting..."; exit 1; }

.PHONY: install
install:
	$(MAKE) prerequisite
	mkdir --parents ~/data/volumes/nextcloud/nextcloud/data/
	mkdir --parents ~/.config/systemd/user/
	ln --symbolic --force --verbose "$(CURDIR)/nextcloud-proxy.socket" ~/.config/systemd/user/
	mkdir --parents ~/.config/containers/systemd/
	ln --symbolic --force --verbose "$(CURDIR)" ~/.config/containers/systemd/
	systemctl --user daemon-reload

.PHONY: uninstall
uninstall:
	rm --force ~/.config/containers/systemd/nextcloud
	rm --force ~/.config/systemd/user/nextcloud-proxy.socket
	systemctl --user daemon-reload

.PHONY: start
start:
	$(MAKE) prerequisite
	systemctl --user daemon-reload
	systemctl --user start nextcloud-pod

.PHONY: stop
stop:
	systemctl --user stop "nextcloud*"

.PHONY: status
status:
	systemctl --user list-units --all "nextcloud*"
	systemctl --user status "nextcloud*"

.PHONY: update
update:
	@echo "Note: Podman auto-update updates all images and containers on the system!"
	podman auto-update

.PHONY: maintenance
maintenance:
	podman exec --user www-data --interactive --tty systemd-nextcloud php occ db:add-missing-indices
	podman exec --user www-data --interactive --tty systemd-nextcloud php occ maintenance:repair --include-expensive

.PHONY: scan
scan:
	podman exec --user www-data --interactive --tty systemd-nextcloud php occ files:scan --all

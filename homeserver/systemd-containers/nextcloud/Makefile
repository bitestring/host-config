.PHONY: prerequisite
prerequisite:
	@which podman || { echo "podman is not installed! Exiting..."; exit 1; }
	@which fail2ban-client || { echo "fail2ban is not installed! Exiting..."; exit 1; }
	@test -s ./caddy/cert.key || { echo "./caddy/cert.key file does not exist! Refer README.md for more info. Exiting..."; exit 1; }
	@test -s ./caddy/cert.pem || { echo "./caddy/cert.pem file does not exist! Refer README.md for more info. Exiting..."; exit 1; }
	@test -s ./.env || { echo ".env file does not exist! Refer README.md for more info. Exiting..."; exit 1; }

.PHONY: install
install:
	$(MAKE) prerequisite

	# fail2ban
	sudo mkdir --parents /etc/fail2ban/filter.d/
	sudo cp ./fail2ban/filter.d/nextcloud.conf /etc/fail2ban/filter.d/
	sudo mkdir --parents /etc/fail2ban/jail.d/
	sudo cp ./fail2ban/jail.d/nextcloud.local /etc/fail2ban/jail.d/

	# data
	mkdir --parents ~/data/volumes/nextcloud/nextcloud/data/

	# systemd
	mkdir --parents ~/.config/systemd/user/
	ln --symbolic --force --verbose "$(CURDIR)/nextcloud-proxy.socket" ~/.config/systemd/user/
	mkdir --parents ~/.config/containers/systemd/
	ln --symbolic --force --verbose "$(CURDIR)" ~/.config/containers/systemd/

	# reload daemons
	sudo fail2ban-client reload
	systemctl --user daemon-reload

.PHONY: uninstall
uninstall:
	# fail2ban
	sudo rm --force /etc/fail2ban/filter.d/nextcloud.conf
	sudo rm --force /etc/fail2ban/jail.d/nextcloud.local

	# systemd
	rm --force ~/.config/containers/systemd/nextcloud
	rm --force ~/.config/systemd/user/nextcloud-proxy.socket

	# reload daemons
	systemctl --user daemon-reload
	sudo fail2ban-client reload

.PHONY: start
start:
	$(MAKE) prerequisite
	systemctl --user daemon-reload
	systemctl --user start nextcloud-pod
	sleep 3
	podman exec --user www-data --interactive --tty systemd-nextcloud php occ config:system:set log_type --value "errorlog"

.PHONY: stop
stop:
	systemctl --user stop nextcloud-pod nextcloud-proxy.socket

.PHONY: list
list:
	-systemctl --user list-units --all "nextcloud*"

.PHONY: status
status:
	-systemctl --user status "nextcloud*"
	-sudo fail2ban-client status nextcloud

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

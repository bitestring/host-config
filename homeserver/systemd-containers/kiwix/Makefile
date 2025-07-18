.PHONY: prerequisite
prerequisite:
	@which podman || { echo "podman is not installed! Exiting..."; exit 1; }
	@test -s ./caddy/cert.key || { echo "./caddy/cert.key file does not exist! Refer README.md for more info. Exiting..."; exit 1; }
	@test -s ./caddy/cert.pem || { echo "./caddy/cert.pem file does not exist! Refer README.md for more info. Exiting..."; exit 1; }

.PHONY: install
install:
	$(MAKE) prerequisite

	# data
	mkdir --parents ~/data/volumes/kiwix/kiwix/data/

	# systemd
	mkdir --parents ~/.config/systemd/user/
	ln --symbolic --force --verbose "$(CURDIR)/kiwix-proxy.socket" ~/.config/systemd/user/
	mkdir --parents ~/.config/containers/systemd/
	ln --symbolic --force --verbose "$(CURDIR)" ~/.config/containers/systemd/

	# reload daemons
	systemctl --user daemon-reload

.PHONY: uninstall
uninstall:
	# systemd
	rm --force ~/.config/containers/systemd/kiwix
	rm --force ~/.config/systemd/user/kiwix-proxy.socket

	# reload daemons
	systemctl --user daemon-reload

.PHONY: start
start:
	$(MAKE) prerequisite
	systemctl --user daemon-reload
	systemctl --user start kiwix-pod

.PHONY: stop
stop:
	systemctl --user stop kiwix-pod kiwix-proxy.socket

.PHONY: list
list:
	-systemctl --user list-units --all "kiwix*"

.PHONY: status
status:
	-systemctl --user status "kiwix*"

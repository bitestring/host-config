.PHONY: prerequisite
prerequisite:
	@which podman || { echo "podman is not installed! Exiting..."; exit 1; }
	@which fail2ban-client || { echo "fail2ban is not installed! Exiting..."; exit 1; }
	@test -s ./caddy/cert.key || { echo "./caddy/cert.key file does not exist! Refer README.md for more info. Exiting..."; exit 1; }
	@test -s ./caddy/cert.crt || { echo "./caddy/cert.crt file does not exist! Refer README.md for more info. Exiting..."; exit 1; }
	@test -s ./.env || { echo ".env file does not exist! Refer README.md for more info. Exiting..."; exit 1; }

.PHONY: install
install:
	$(MAKE) prerequisite

	# fail2ban
	sudo mkdir --parents /etc/fail2ban/filter.d/
	sudo cp ./fail2ban/filter.d/paperless-ngx.conf /etc/fail2ban/filter.d/
	sudo mkdir --parents /etc/fail2ban/jail.d/
	sudo cp ./fail2ban/jail.d/paperless-ngx.local /etc/fail2ban/jail.d/

	# data
	mkdir --parents ~/data/volumes/paperless-ngx/paperless-ngx-redis/data
	mkdir --parents ~/data/volumes/paperless-ngx/paperless-ngx/data
	mkdir --parents ~/data/volumes/paperless-ngx/paperless-ngx/media
	mkdir --parents ~/data/volumes/paperless-ngx/paperless-ngx/export
	mkdir --parents ~/data/volumes/paperless-ngx/paperless-ngx/consume

	# systemd
	mkdir --parents ~/.config/systemd/user/
	ln --symbolic --force --verbose "$(CURDIR)/paperless-ngx-proxy.socket" ~/.config/systemd/user/
	mkdir --parents ~/.config/containers/systemd/
	ln --symbolic --force --verbose "$(CURDIR)" ~/.config/containers/systemd/

	# reload daemons
	sudo fail2ban-client reload
	systemctl --user daemon-reload

.PHONY: uninstall
uninstall:
	# fail2ban
	sudo rm --force /etc/fail2ban/filter.d/paperless-ngx.conf
	sudo rm --force /etc/fail2ban/jail.d/paperless-ngx.local

	# systemd
	rm --force ~/.config/containers/systemd/paperless-ngx
	rm --force ~/.config/systemd/user/paperless-ngx-proxy.socket

	# reload daemons
	systemctl --user daemon-reload
	sudo fail2ban-client reload

.PHONY: start
start:
	$(MAKE) prerequisite
	systemctl --user daemon-reload
	systemctl --user start paperless-ngx-pod

.PHONY: stop
stop:
	systemctl --user stop paperless-ngx-pod paperless-ngx-proxy.socket

.PHONY: list
list:
	-systemctl --user list-units --all "paperless-ngx*"

.PHONY: status
status:
	-systemctl --user status "paperless-ngx*"
	-sudo fail2ban-client status paperless-ngx

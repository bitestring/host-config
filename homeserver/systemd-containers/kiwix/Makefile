.PHONY: cert
cert:
ifneq ("$(wildcard ./caddy/cert.key)", "")
	@echo "./caddy/cert.key file already exists. Not generating TLS certificate."
else ifneq ("$(wildcard ./caddy/cert.crt)", "")
	@echo "./caddy/cert.crt file already exists. Not generating TLS certificate."
else
	@echo "IMPORTANT: Make sure to enter your server domain name during the Common Name (e.g. server FQDN or YOUR name) [] prompt."
	openssl req -x509 -newkey ec -pkeyopt ec_paramgen_curve:prime256v1 -days 36500 -noenc -keyout ./caddy/cert.key -out ./caddy/cert.crt
endif

.PHONY: prerequisite
prerequisite:
	@which podman || { echo "podman is not installed! Exiting..."; exit 1; }
	@which fail2ban-client || { echo "fail2ban is not installed! Exiting..."; exit 1; }
	@which openssl || { echo "openssl is not installed! Exiting..."; exit 1; }
	$(MAKE) cert
	@test -s ./caddy/cert.key || { echo "./caddy/cert.key file does not exist! Refer README.md for more info. Exiting..."; exit 1; }
	@test -s ./caddy/cert.crt || { echo "./caddy/cert.crt file does not exist! Refer README.md for more info. Exiting..."; exit 1; }

.PHONY: install
install:
	$(MAKE) prerequisite

	# fail2ban
	sudo mkdir --parents /etc/fail2ban/filter.d/
	sudo cp ./fail2ban/filter.d/kiwix.conf /etc/fail2ban/filter.d/
	sudo mkdir --parents /etc/fail2ban/jail.d/
	sudo cp ./fail2ban/jail.d/kiwix.local /etc/fail2ban/jail.d/

	# data
	mkdir --parents ~/data/volumes/kiwix/kiwix/data/

	# systemd
	mkdir --parents ~/.config/systemd/user/
	ln --symbolic --force --verbose "$(CURDIR)/kiwix-proxy.socket" ~/.config/systemd/user/
	mkdir --parents ~/.config/containers/systemd/
	ln --symbolic --force --verbose "$(CURDIR)" ~/.config/containers/systemd/

	# reload daemons
	sudo fail2ban-client reload
	systemctl --user daemon-reload

.PHONY: uninstall
uninstall:
	# fail2ban
	sudo rm --force /etc/fail2ban/filter.d/kiwix.conf
	sudo rm --force /etc/fail2ban/jail.d/kiwix.local

	# systemd
	rm --force ~/.config/containers/systemd/kiwix
	rm --force ~/.config/systemd/user/kiwix-proxy.socket

	# reload daemons
	systemctl --user daemon-reload
	sudo fail2ban-client reload

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
	-sudo fail2ban-client status kiwix

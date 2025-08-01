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
	@test -s ./.env || { echo ".env file does not exist! Refer README.md for more info. Exiting..."; exit 1; }

.PHONY: install
install:
	$(MAKE) prerequisite

	# systemd
	mkdir --parents ~/.config/containers/systemd/
	ln --symbolic --force --verbose "$(CURDIR)" ~/.config/containers/systemd/

	# reload daemons
	systemctl --user daemon-reload

	@echo "SUCCESS!"

.PHONY: uninstall
uninstall:
	# systemd
	rm --force ~/.config/containers/systemd/wazuh-central

	# reload daemons
	systemctl --user daemon-reload

.PHONY: start
start:
	$(MAKE) prerequisite
	systemctl --user daemon-reload
	systemctl --user start wazuh-central-pod

.PHONY: stop
stop:
	systemctl --user stop wazuh-central-pod

.PHONY: list
list:
	-systemctl --user list-units --all "wazuh*"

.PHONY: status
status:
	-systemctl --user status "wazuh*"

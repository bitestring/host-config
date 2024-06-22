.PHONY: update
update:
	nix flake update
	sudo nixos-rebuild boot --flake '.#'
	git add flake.lock
	git commit -m "NixOS Flakes update"
	git pull --rebase
	git push

.PHONY: boot
boot:
	sudo nixos-rebuild boot --flake '.#'

.PHONY: switch
switch:
	sudo nixos-rebuild switch --flake '.#'

.PHONY: gc
gc:
	sudo nix-collect-garbage --delete-older-than 30d
	nix-collect-garbage --delete-older-than 30d

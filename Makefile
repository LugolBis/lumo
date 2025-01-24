SHELL := /bin/bash

config:
	@chmod +x main.sh
	@unalias lumo 2>/dev/null || true; \
	unset -f lumo 2>/dev/null || true; \
	PATH_SCRIPT="$(shell pwd)/main.sh"; \
	function lumo() { bash "$$PATH_SCRIPT" "$$@"; }; \
	echo 'function lumo() { bash "'"$$PATH_SCRIPT"'" "$$@"; }' >> ~/.bashrc; \
	source ~/.bashrc; \
	echo "Command 'lumo' is configurated"
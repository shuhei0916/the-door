SCRIPTS := scripts/door.gd scripts/door_wheel.gd scripts/player.gd scripts/main.gd scripts/pause_menu.gd

.PHONY: lint format test

lint:
	gdlint $(SCRIPTS)

format:
	gdformat $(SCRIPTS)

test:
	godot --headless --script addons/gut/gut_cmdln.gd -gdir=res://tests/ -ginclude_subdirs -gexit

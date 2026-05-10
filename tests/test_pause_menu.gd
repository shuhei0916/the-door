extends GutTest

const PauseMenuScene: PackedScene = preload("res://scenes/ui/pause_menu.tscn")

func after_each() -> void:
	get_tree().paused = false

func test_pause_menu_starts_hidden() -> void:
	var menu: PauseMenu = PauseMenuScene.instantiate()
	add_child_autofree(menu)
	assert_false(menu.visible)

func test_show_menu_makes_visible() -> void:
	var menu: PauseMenu = PauseMenuScene.instantiate()
	add_child_autofree(menu)
	menu.show_menu()
	assert_true(menu.visible)

func test_hide_menu_makes_invisible() -> void:
	var menu: PauseMenu = PauseMenuScene.instantiate()
	add_child_autofree(menu)
	menu.show_menu()
	menu.hide_menu()
	assert_false(menu.visible)

func test_show_menu_pauses_tree() -> void:
	var menu: PauseMenu = PauseMenuScene.instantiate()
	add_child_autofree(menu)
	menu.show_menu()
	assert_true(get_tree().paused)

func test_hide_menu_unpauses_tree() -> void:
	var menu: PauseMenu = PauseMenuScene.instantiate()
	add_child_autofree(menu)
	menu.show_menu()
	menu.hide_menu()
	assert_false(get_tree().paused)

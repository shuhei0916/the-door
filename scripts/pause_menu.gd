class_name PauseMenu
extends CanvasLayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$Overlay.color = Color(0.0, 0.0, 0.0, 0.6)
	$Overlay.anchor_right = 1.0
	$Overlay.anchor_bottom = 1.0
	var panel: Control = $Panel
	panel.anchor_left = 0.5
	panel.anchor_right = 0.5
	panel.anchor_top = 0.5
	panel.anchor_bottom = 0.5
	panel.offset_left = -120.0
	panel.offset_right = 120.0
	panel.offset_top = -80.0
	panel.offset_bottom = 80.0
	$Panel/VBox/ResumeButton.pressed.connect(hide_menu)
	$Panel/VBox/ExitButton.pressed.connect(_on_exit)


func show_menu() -> void:
	visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func hide_menu() -> void:
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		hide_menu()
		get_viewport().set_input_as_handled()


func _on_exit() -> void:
	get_tree().quit()

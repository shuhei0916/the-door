extends Node3D

@onready var _player: Player = $Player
@onready var _debug_label: Label = $HUD/DebugLabel
@onready var _door_wheel: DoorWheel = $DoorWheel
@onready var _pause_menu: PauseMenu = $PauseMenu

var _current_door: Door = null

func _ready() -> void:
	get_tree().debug_collisions_hint = false
	_player.interact_hold_started.connect(_on_interact_hold_started)
	_door_wheel.destination_selected.connect(_on_destination_selected)
	_door_wheel.cancelled.connect(_on_wheel_cancelled)

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel"):
		return
	if _player.is_interacting_with_wheel:
		return
	if _pause_menu.visible:
		_pause_menu.hide_menu()
	else:
		_pause_menu.show_menu()
	get_viewport().set_input_as_handled()

func _process(_delta: float) -> void:
	var pos: Vector3 = _player.global_position
	_debug_label.text = "Pos: (%.1f, %.1f, %.1f)" % [pos.x, pos.y, pos.z]

func _on_interact_hold_started(door: Door) -> void:
	match door.state:
		Door.State.OPEN:
			door.close()
		Door.State.CLOSED:
			_current_door = door
			_player.is_interacting_with_wheel = true
			_door_wheel.show_for_door(door)

func _on_destination_selected(dest_door: Door) -> void:
	_player.is_interacting_with_wheel = false
	_door_wheel.hide_wheel()
	if _current_door:
		_current_door.open(dest_door)
	_current_door = null

func _on_wheel_cancelled() -> void:
	_player.is_interacting_with_wheel = false
	_door_wheel.hide_wheel()
	_current_door = null

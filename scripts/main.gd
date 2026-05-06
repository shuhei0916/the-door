extends Node3D

@onready var _player: Player = $Player
@onready var _debug_label: Label = $HUD/DebugLabel
@onready var _door_wheel: DoorWheel = $DoorWheel

func _ready() -> void:
	_player.interact_hold_started.connect(_on_interact_hold_started)
	_door_wheel.destination_selected.connect(_on_destination_selected)
	_door_wheel.cancelled.connect(_on_wheel_cancelled)

func _process(_delta: float) -> void:
	var pos: Vector3 = _player.global_position
	_debug_label.text = "Pos: (%.1f, %.1f, %.1f)" % [pos.x, pos.y, pos.z]

func _on_interact_hold_started(door: Door) -> void:
	_player.is_interacting_with_wheel = true
	_door_wheel.show_for_door(door)

func _on_destination_selected(dest_door: Door) -> void:
	_player.is_interacting_with_wheel = false
	_door_wheel.hide_wheel()
	_player.teleport_to(dest_door.get_spawn_transform())

func _on_wheel_cancelled() -> void:
	_player.is_interacting_with_wheel = false
	_door_wheel.hide_wheel()

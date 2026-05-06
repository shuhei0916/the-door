extends Node3D

@onready var _door_a: Door = $SpaceA/DoorA
@onready var _door_b: Door = $SpaceB/DoorB
@onready var _player: Player = $Player
@onready var _debug_label: Label = $HUD/DebugLabel

func _ready() -> void:
	_door_a.linked_door = _door_b
	_door_b.linked_door = _door_a
	_door_a.teleport_requested.connect(func(body: Node3D) -> void: _on_teleport(body, _door_a))
	_door_b.teleport_requested.connect(func(body: Node3D) -> void: _on_teleport(body, _door_b))

func _process(_delta: float) -> void:
	var pos: Vector3 = _player.global_position
	_debug_label.text = "Pos: (%.1f, %.1f, %.1f)" % [pos.x, pos.y, pos.z]

func _on_teleport(body: Node3D, from_door: Door) -> void:
	if from_door.linked_door == null:
		return
	if body is Player:
		(body as Player).teleport_to(from_door.linked_door.get_spawn_transform())

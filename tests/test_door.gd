extends GutTest

const DoorScene: PackedScene = preload("res://scenes/objects/door.tscn")

func test_door_can_be_instantiated() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	assert_not_null(door)

func test_linked_door_is_null_by_default() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	assert_null(door.linked_door)

func test_get_spawn_transform_returns_transform3d() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	assert_true(door.get_spawn_transform() is Transform3D, "should return Transform3D")

func test_teleport_requested_emitted_when_player_enters() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	watch_signals(door)

	var player_body: CharacterBody3D = CharacterBody3D.new()
	player_body.add_to_group("player")
	add_child_autofree(player_body)

	door._on_trigger_area_body_entered(player_body)

	assert_signal_emitted(door, "teleport_requested")

func test_non_player_body_does_not_trigger_teleport() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	watch_signals(door)

	var other_body: CharacterBody3D = CharacterBody3D.new()
	add_child_autofree(other_body)

	door._on_trigger_area_body_entered(other_body)

	assert_signal_not_emitted(door, "teleport_requested")

func test_cooldown_prevents_double_teleport() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	watch_signals(door)

	var player_body: CharacterBody3D = CharacterBody3D.new()
	player_body.add_to_group("player")
	add_child_autofree(player_body)

	door._on_trigger_area_body_entered(player_body)
	door._on_trigger_area_body_entered(player_body)

	assert_signal_emit_count(door, "teleport_requested", 1)

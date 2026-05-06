extends GutTest

const DoorScene: PackedScene = preload("res://scenes/objects/door.tscn")
const PlayerScene: PackedScene = preload("res://scenes/player/player.tscn")

func test_door_can_be_instantiated() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	assert_not_null(door)

func test_door_id_is_empty_by_default() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	assert_eq(door.door_id, "")

func test_display_name_is_empty_by_default() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	assert_eq(door.display_name, "")

func test_door_registers_on_ready() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	assert_true(door.is_in_group("doors"))

func test_get_spawn_transform_returns_transform3d() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	assert_true(door.get_spawn_transform() is Transform3D, "should return Transform3D")

func test_get_destinations_returns_other_doors() -> void:
	var door_a: Door = DoorScene.instantiate()
	var door_b: Door = DoorScene.instantiate()
	add_child_autofree(door_a)
	add_child_autofree(door_b)
	var dests: Array[Door] = door_a.get_destinations()
	assert_eq(dests.size(), 1)
	assert_true(dests.has(door_b))

func test_interact_random_does_nothing_when_no_destinations() -> void:
	var door: Door = DoorScene.instantiate()
	var player: Player = PlayerScene.instantiate()
	add_child_autofree(door)
	add_child_autofree(player)
	var initial_pos: Vector3 = player.global_position
	door.interact_random(player)
	assert_eq(player.global_position, initial_pos)

func test_interact_random_moves_player_to_another_door() -> void:
	var door_a: Door = DoorScene.instantiate()
	var door_b: Door = DoorScene.instantiate()
	var player: Player = PlayerScene.instantiate()
	add_child_autofree(door_a)
	add_child_autofree(door_b)
	add_child_autofree(player)
	door_b.global_position = Vector3(50.0, 0.0, 0.0)
	player.global_position = Vector3(0.0, 0.0, 0.0)
	door_a.interact_random(player)
	assert_true(
		player.global_position.distance_to(door_b.get_spawn_transform().origin) < 0.01,
		"player should be near door_b spawn"
	)

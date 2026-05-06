extends GutTest

const DoorScene: PackedScene = preload("res://scenes/objects/door.tscn")

func test_registry_starts_empty() -> void:
	assert_eq(get_tree().get_nodes_in_group("doors").size(), 0)

func test_register_adds_door() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	assert_eq(get_tree().get_nodes_in_group("doors").size(), 1)

func test_unregister_removes_door() -> void:
	var door: Door = DoorScene.instantiate()
	add_child(door)
	assert_eq(get_tree().get_nodes_in_group("doors").size(), 1)
	remove_child(door)
	door.free()
	assert_eq(get_tree().get_nodes_in_group("doors").size(), 0)

func test_get_other_doors_excludes_self() -> void:
	var door_a: Door = DoorScene.instantiate()
	var door_b: Door = DoorScene.instantiate()
	add_child_autofree(door_a)
	add_child_autofree(door_b)
	var others: Array[Door] = door_a.get_destinations()
	assert_eq(others.size(), 1)
	assert_true(others.has(door_b))
	assert_false(others.has(door_a))

func test_get_nearest_door_returns_closest() -> void:
	var door_a: Door = DoorScene.instantiate()
	var door_b: Door = DoorScene.instantiate()
	add_child_autofree(door_a)
	add_child_autofree(door_b)
	door_a.global_position = Vector3(1.0, 0.0, 0.0)
	door_b.global_position = Vector3(10.0, 0.0, 0.0)
	var nearest: Door = Door.get_nearest(get_tree(), Vector3(0.0, 0.0, 0.0), 5.0)
	assert_eq(nearest, door_a)

func test_get_nearest_door_returns_null_when_none_in_range() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	door.global_position = Vector3(100.0, 0.0, 0.0)
	var nearest: Door = Door.get_nearest(get_tree(), Vector3(0.0, 0.0, 0.0), 2.5)
	assert_null(nearest)

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

func test_door_has_linked_door_property() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	assert_true("linked_door" in door)

func test_portal_surface_exists() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	assert_not_null(door.get_node_or_null("PortalSurface"))

func test_door_starts_in_closed_state() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	assert_eq(door.state, Door.State.CLOSED)

func test_portal_hidden_when_door_closed() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	var portal := door.get_node_or_null("PortalSurface")
	assert_false(portal.visible)

func test_open_transitions_to_opening_state() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	door.open()
	assert_eq(door.state, Door.State.OPENING)

func test_open_without_hinge_goes_to_open_state() -> void:
	var door: Door = DoorScene.instantiate()
	add_child_autofree(door)
	var hinge := door.get_node_or_null("HingePoint")
	if hinge:
		door.remove_child(hinge)
		hinge.queue_free()
	door.open()
	assert_eq(door.state, Door.State.OPEN)

func test_open_sets_linked_door() -> void:
	var door_a: Door = DoorScene.instantiate()
	var door_b: Door = DoorScene.instantiate()
	add_child_autofree(door_a)
	add_child_autofree(door_b)
	door_a.open(door_b)
	assert_eq(door_a.linked_door, door_b)

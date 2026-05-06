extends GutTest

const PlayerScene: PackedScene = preload("res://scenes/player/player.tscn")

func test_player_can_be_instantiated() -> void:
	var player: Player = PlayerScene.instantiate()
	add_child_autofree(player)
	assert_not_null(player)

func test_velocity_is_zero_on_init() -> void:
	var player: Player = PlayerScene.instantiate()
	add_child_autofree(player)
	assert_eq(player.velocity, Vector3.ZERO)

func test_get_input_direction_returns_vector2() -> void:
	var player: Player = PlayerScene.instantiate()
	add_child_autofree(player)
	var dir: Vector2 = player._get_input_direction()
	assert_true(dir is Vector2, "should return Vector2")

func test_get_input_direction_is_zero_without_input() -> void:
	var player: Player = PlayerScene.instantiate()
	add_child_autofree(player)
	assert_eq(player._get_input_direction(), Vector2.ZERO)

func test_teleport_to_sets_position() -> void:
	var player: Player = PlayerScene.instantiate()
	add_child_autofree(player)
	player.teleport_to(Transform3D(Basis(), Vector3(10.0, 0.0, 5.0)))
	assert_eq(player.global_position, Vector3(10.0, 0.0, 5.0))

func test_teleport_to_resets_velocity() -> void:
	var player: Player = PlayerScene.instantiate()
	add_child_autofree(player)
	player.velocity = Vector3(5.0, 0.0, 3.0)
	player.teleport_to(Transform3D())
	assert_eq(player.velocity, Vector3.ZERO)

func test_teleport_to_sets_facing_direction() -> void:
	var player: Player = PlayerScene.instantiate()
	add_child_autofree(player)
	var rotated_basis: Basis = Basis().rotated(Vector3.UP, PI)
	player.teleport_to(Transform3D(rotated_basis, Vector3.ZERO))
	assert_true(absf(player.rotation.y - PI) < 0.01, "should face PI after 180-degree rotation")

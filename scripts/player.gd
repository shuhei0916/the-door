class_name Player
extends CharacterBody3D

const SPEED: float = 5.0
const JUMP_VELOCITY: float = 4.5
const MOUSE_SENSITIVITY: float = 0.002

@onready var _camera: Camera3D = $Camera3D

func _ready() -> void:
	if DisplayServer.get_name() != "headless":
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir: Vector2 = _get_input_direction()
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		_camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		_camera.rotation.x = clamp(_camera.rotation.x, -PI / 2.0, PI / 2.0)
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _get_input_direction() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_forward", "move_back")

func teleport_to(target_transform: Transform3D) -> void:
	global_position = target_transform.origin
	rotation.y = target_transform.basis.get_euler().y
	_camera.rotation.x = 0.0
	velocity = Vector3.ZERO

class_name Door
extends Node3D

enum State { CLOSED, OPENING, OPEN, CLOSING }

@export var door_id: String = ""
@export var display_name: String = ""

var state: State = State.CLOSED

signal opened
signal closed

func _ready() -> void:
	add_to_group("doors")
	_update_portal_state()
	call_deferred("_update_portal_state")
	call_deferred("_connect_portal_teleport")

func _exit_tree() -> void:
	remove_from_group("doors")

func open(destination: Door = null) -> void:
	if state != State.CLOSED:
		return
	state = State.OPENING
	if destination:
		_link_portal(destination)
	_update_portal_state()
	_start_open_animation()

func close() -> void:
	if state != State.OPEN:
		return
	state = State.CLOSING
	_start_close_animation()

func _start_open_animation() -> void:
	var hinge: Node3D = get_node_or_null("HingePoint")
	if hinge == null:
		_on_open_done()
		return
	var tween: Tween = create_tween()
	tween.tween_property(hinge, "rotation:y", -PI / 2.0, 0.8)
	tween.tween_callback(_on_open_done)

func _on_open_done() -> void:
	state = State.OPEN
	_update_portal_state()
	opened.emit()

func _start_close_animation() -> void:
	var hinge: Node3D = get_node_or_null("HingePoint")
	if hinge == null:
		_on_close_done()
		return
	var tween: Tween = create_tween()
	tween.tween_property(hinge, "rotation:y", 0.0, 0.8)
	tween.tween_callback(_on_close_done)

func _on_close_done() -> void:
	state = State.CLOSED
	_update_portal_state()
	closed.emit()

func _update_portal_state() -> void:
	var portal: Portal = get_node_or_null("PortalSurface")
	if portal == null:
		return
	var is_open: bool = (state == State.OPEN)
	portal.visible = is_open
	var teleport: Area3D = portal.get_node_or_null("PortalTeleport")
	if teleport:
		teleport.monitoring = is_open

func _link_portal(destination: Door) -> void:
	var my_portal: Portal = get_node_or_null("PortalSurface")
	var exit_portal_node: Portal = destination.get_node_or_null("PortalSurface")
	if my_portal and exit_portal_node:
		my_portal.exit_portal = exit_portal_node

func _connect_portal_teleport() -> void:
	var portal: Portal = get_node_or_null("PortalSurface")
	if portal == null:
		return
	var teleport: Area3D = portal.get_node_or_null("PortalTeleport")
	if teleport and not teleport.teleported.is_connected(_on_portal_teleported):
		teleport.teleported.connect(_on_portal_teleported)

func _on_portal_teleported(_root: Node3D) -> void:
	close()

func get_spawn_transform() -> Transform3D:
	return $SpawnPoint.global_transform

func get_destinations() -> Array[Door]:
	var result: Array[Door] = []
	for node in get_tree().get_nodes_in_group("doors"):
		if node != self and node is Door:
			result.append(node as Door)
	return result

static func get_nearest(tree: SceneTree, from: Vector3, max_dist: float) -> Door:
	var nearest: Door = null
	var nearest_sq: float = max_dist * max_dist
	for node in tree.get_nodes_in_group("doors"):
		if node is Door:
			var sq: float = from.distance_squared_to((node as Door).global_position)
			if sq < nearest_sq:
				nearest_sq = sq
				nearest = node as Door
	return nearest

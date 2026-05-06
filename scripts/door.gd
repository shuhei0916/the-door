class_name Door
extends Node3D

@export var door_id: String = ""
@export var display_name: String = ""

func _ready() -> void:
	add_to_group("doors")

func _exit_tree() -> void:
	remove_from_group("doors")

func get_spawn_transform() -> Transform3D:
	return $SpawnPoint.global_transform

func get_destinations() -> Array[Door]:
	var result: Array[Door] = []
	for node in get_tree().get_nodes_in_group("doors"):
		if node != self and node is Door:
			result.append(node as Door)
	return result

func interact_random(player: Node3D) -> void:
	var dests: Array[Door] = get_destinations()
	if dests.is_empty():
		return
	player.teleport_to(dests.pick_random().get_spawn_transform())

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

class_name Door
extends Node3D

signal teleport_requested(body: Node3D)

@export var linked_door: Door = null

const TELEPORT_COOLDOWN: float = 1.0

var _on_cooldown: bool = false

func get_spawn_transform() -> Transform3D:
	return $SpawnPoint.global_transform

func _on_trigger_area_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	if _on_cooldown:
		return
	teleport_requested.emit(body)
	_start_cooldown()

func _start_cooldown() -> void:
	_on_cooldown = true
	$CooldownTimer.start(TELEPORT_COOLDOWN)

func _on_cooldown_timer_timeout() -> void:
	_on_cooldown = false

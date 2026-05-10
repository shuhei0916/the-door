extends GutTest

const DoorWheelScene: PackedScene = preload("res://scenes/ui/door_wheel.tscn")

func test_sector_index_at_button_angle() -> void:
	var wheel: DoorWheel = DoorWheelScene.instantiate()
	add_child_autofree(wheel)
	var count: int = 3
	# button 2 is at angle (TAU/3)*2 - PI/2
	var btn2_angle: float = (TAU / 3.0) * 2.0 - PI / 2.0
	assert_eq(wheel._get_sector_index(btn2_angle, count), 2,
		"pointing exactly at button 2 should select index 2")

func test_sector_is_centered_on_button() -> void:
	var wheel: DoorWheel = DoorWheelScene.instantiate()
	add_child_autofree(wheel)
	var count: int = 3
	# button 2 is at angle (TAU/3)*2 - PI/2 ≈ 2.618 rad (lower-left)
	var btn2_angle: float = (TAU / 3.0) * 2.0 - PI / 2.0
	# pointing 0.3 rad counterclockwise from button 2 should still select index 2
	assert_eq(wheel._get_sector_index(btn2_angle - 0.3, count), 2,
		"pointing slightly CCW from button 2 should still select index 2")

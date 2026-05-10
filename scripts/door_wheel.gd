class_name DoorWheel
extends CanvasLayer

signal destination_selected(door: Door)
signal cancelled

const WHEEL_RADIUS: float = 120.0
const BUTTON_SIZE: Vector2 = Vector2(160.0, 50.0)

@onready var _overlay: ColorRect = $Overlay
@onready var _wheel_container: Control = $WheelContainer
@onready var _hint_label: Label = $HintLabel

var _option_buttons: Array[Button] = []
var _option_doors: Array[Door] = []
var _highlighted_index: int = -1

func _ready() -> void:
	_overlay.color = Color(0.0, 0.0, 0.0, 0.55)
	_overlay.anchor_right = 1.0
	_overlay.anchor_bottom = 1.0

	_wheel_container.anchor_left = 0.5
	_wheel_container.anchor_right = 0.5
	_wheel_container.anchor_top = 0.5
	_wheel_container.anchor_bottom = 0.5
	_wheel_container.offset_left = -150.0
	_wheel_container.offset_right = 150.0
	_wheel_container.offset_top = -150.0
	_wheel_container.offset_bottom = 150.0

	_hint_label.anchor_left = 0.0
	_hint_label.anchor_right = 1.0
	_hint_label.anchor_top = 1.0
	_hint_label.anchor_bottom = 1.0
	_hint_label.offset_top = -60.0
	_hint_label.offset_bottom = -20.0
	_hint_label.text = "目的地を選択  /  E: 確定  /  ESC: キャンセル"
	_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hint_label.add_theme_color_override("font_color", Color.WHITE)
	_hint_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_hint_label.add_theme_constant_override("outline_size", 2)

func show_for_door(from_door: Door) -> void:
	var dests: Array[Door] = from_door.get_destinations()
	_build_wheel(dests)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true

func hide_wheel() -> void:
	visible = false
	_highlighted_index = -1
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _build_wheel(dests: Array[Door]) -> void:
	for btn in _option_buttons:
		btn.queue_free()
	_option_buttons.clear()
	_option_doors = dests

	if dests.is_empty():
		return

	var center: Vector2 = Vector2(150.0, 150.0)
	for i in dests.size():
		var angle: float = (TAU / dests.size()) * i - PI / 2.0
		var pos: Vector2 = center + Vector2(cos(angle), sin(angle)) * WHEEL_RADIUS - BUTTON_SIZE / 2.0

		var btn: Button = Button.new()
		var label: String = dests[i].display_name if not dests[i].display_name.is_empty() else dests[i].door_id
		btn.text = label if not label.is_empty() else "不明な扉"
		btn.custom_minimum_size = BUTTON_SIZE
		btn.position = pos
		_wheel_container.add_child(btn)
		_option_buttons.append(btn)

func _process(_delta: float) -> void:
	if not visible:
		return
	_update_highlight()

	if Input.is_action_just_released("interact"):
		if _highlighted_index >= 0 and _highlighted_index < _option_doors.size():
			destination_selected.emit(_option_doors[_highlighted_index])
		else:
			cancelled.emit()

	if Input.is_action_just_pressed("ui_cancel"):
		cancelled.emit()

func _update_highlight() -> void:
	if _option_doors.is_empty():
		return

	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var screen_center: Vector2 = viewport_size / 2.0
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var dir: Vector2 = mouse_pos - screen_center

	if dir.length() < 20.0:
		_set_highlight(-1)
		return

	var angle: float = dir.angle()
	_set_highlight(_get_sector_index(angle, _option_doors.size()))

func _get_sector_index(angle: float, count: int) -> int:
	var sector_size: float = TAU / float(count)
	var normalized: float = fposmod(angle + PI / 2.0 + sector_size / 2.0, TAU)
	return int(normalized / sector_size) % count

func _set_highlight(idx: int) -> void:
	if _highlighted_index == idx:
		return
	if _highlighted_index >= 0 and _highlighted_index < _option_buttons.size():
		_option_buttons[_highlighted_index].modulate = Color.WHITE
	_highlighted_index = idx
	if _highlighted_index >= 0 and _highlighted_index < _option_buttons.size():
		_option_buttons[_highlighted_index].modulate = Color(0.3, 1.0, 0.5, 1.0)

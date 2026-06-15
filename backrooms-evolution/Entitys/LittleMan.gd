extends CharacterBody2D

const SPEED := 120.0
const SIZE := 32.0

var _dragging := false
var _drag_offset := Vector2.ZERO


func _ready() -> void:
	pick_random_direction()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var mouse := get_global_mouse_position()
			if (mouse - global_position).length() <= SIZE:
				_dragging = true
				_drag_offset = mouse - global_position
		else:
			if _dragging:
				_dragging = false
				pick_random_direction()

	elif event is InputEventScreenTouch:
		if event.pressed:
			if (event.position - global_position).length() <= SIZE:
				_dragging = true
				_drag_offset = event.position - global_position
		else:
			if _dragging:
				_dragging = false
				pick_random_direction()


func _process(_delta: float) -> void:
	if not _dragging:
		return
	position = get_global_mouse_position() - _drag_offset


func _physics_process(_delta: float) -> void:
	if _dragging:
		return
	var collision := move_and_collide(velocity * _delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())


func pick_random_direction() -> void:
	var angle := randf() * TAU
	velocity = Vector2(cos(angle), sin(angle)) * SPEED

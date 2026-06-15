extends CharacterBody2D

const SIZE := 32.0
const LITTLEMAN_SCENE = preload("res://Entitys/LittleMan.tscn")

var entity_data: EntityData = null
var _dragging := false
var _drag_offset := Vector2.ZERO
var _merging := false

@onready var visual: ColorRect = $Visual
@onready var merge_area: Area2D = $MergeArea


func _ready() -> void:
	if entity_data == null:
		entity_data = EntityRegistry.get_starting_type()
	apply_type()
	pick_random_direction()


func apply_type() -> void:
	visual.color = entity_data.color


func _input(event: InputEvent) -> void:
	if _merging:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var mouse := get_global_mouse_position()
			if (mouse - global_position).length() <= SIZE:
				_dragging = true
				_drag_offset = mouse - global_position
		else:
			if _dragging:
				_dragging = false
				try_merge()
				if not _merging:
					pick_random_direction()
	elif event is InputEventScreenTouch:
		if event.pressed:
			if (event.position - global_position).length() <= SIZE:
				_dragging = true
				_drag_offset = event.position - global_position
		else:
			if _dragging:
				_dragging = false
				try_merge()
				if not _merging:
					pick_random_direction()


func _process(_delta: float) -> void:
	if not _dragging:
		return
	position = get_global_mouse_position() - _drag_offset


func _physics_process(_delta: float) -> void:
	if _dragging or _merging:
		return
	var collision := move_and_collide(velocity * _delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())


func try_merge() -> void:
	var next_type := EntityRegistry.get_next_type(entity_data)
	if next_type == null:
		return  # tipo máximo, não evolui

	for body in merge_area.get_overlapping_bodies():
		if body == self:
			continue
		if not body.has_method("start_merge"):
			continue
		if body.entity_data != entity_data:
			continue

		# Encontrou par — executa merge
		var mid := (global_position + body.global_position) / 2.0
		body.start_merge()
		start_merge()

		var new_entity: CharacterBody2D = LITTLEMAN_SCENE.instantiate()
		new_entity.entity_data = next_type
		new_entity.position = mid
		get_parent().add_child(new_entity)
		return


func start_merge() -> void:
	_merging = true
	queue_free()


func pick_random_direction() -> void:
	var angle := randf() * TAU
	velocity = Vector2(cos(angle), sin(angle)) * entity_data.speed

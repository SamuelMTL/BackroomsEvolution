extends Node2D

@export var spawn_interval: float = 10.0

const LittleMan = preload("res://Entitys/LittleMan.tscn")

# Área jogável (dentro das paredes)
const SPAWN_AREA := Rect2(136, 121, 814, 1683)

@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	var little_man := LittleMan.instantiate()
	little_man.position = Vector2(
		randf_range(SPAWN_AREA.position.x, SPAWN_AREA.end.x),
		randf_range(SPAWN_AREA.position.y, SPAWN_AREA.end.y)
	)
	add_child(little_man)

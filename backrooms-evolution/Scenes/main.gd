extends Node2D

@export var spawn_interval: float = 5.0

const LittleMan = preload("res://Entitys/LittleMan.tscn")
const SPAWN_AREA := Rect2(117, 197, 857, 1533)

@onready var spawn_timer: Timer = $SpawnTimer
@onready var shop_ui = $ShopUI
@onready var shop_btn: Button = $ShopButton/Button


func _ready() -> void:
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()
	ShopManager.entity_purchased.connect(_on_entity_purchased)
	shop_btn.pressed.connect(shop_ui.open)


func _on_spawn_timer_timeout() -> void:
	_spawn_entity(EntityRegistry.get_starting_type())


func _on_entity_purchased(entity_data: EntityData) -> void:
	_spawn_entity(entity_data)


func _spawn_entity(entity_data: EntityData) -> void:
	var little_man := LittleMan.instantiate()
	little_man.entity_data = entity_data
	little_man.position = Vector2(
		randf_range(SPAWN_AREA.position.x, SPAWN_AREA.end.x),
		randf_range(SPAWN_AREA.position.y, SPAWN_AREA.end.y)
	)
	add_child(little_man)

extends Node

# Adicione novos tipos aqui na ordem de evolução.
# O jogo sempre começa spawnando types[0].
var types: Array[EntityData] = []

func _ready() -> void:
	types = [
		preload("res://Resources/Type01.tres"),
		preload("res://Resources/Type02.tres"),
		preload("res://Resources/Type03.tres"),
		preload("res://Resources/Type04.tres"),
		preload("res://Resources/Type05.tres"),
	]

func get_starting_type() -> EntityData:
	return types[0]

func get_next_type(current: EntityData) -> EntityData:
	var idx := types.find(current)
	if idx == -1 or idx >= types.size() - 1:
		return null
	return types[idx + 1]

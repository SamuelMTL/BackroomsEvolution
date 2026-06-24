extends Node

# Add new types here in evolution order.
# The game always starts spawning types[0].
var types: Array[EntityData] = []

# Base shop buy prices
const BUY_PRICES: Array[float] = [15.0, 75.0, 375.0, 1875.0, 9375.0]

func _ready() -> void:
	types = [
		preload("res://Resources/Type01.tres"),
		preload("res://Resources/Type02.tres"),
		preload("res://Resources/Type03.tres"),
		preload("res://Resources/Type04.tres"),
		preload("res://Resources/Type05.tres"),
	]

	var upgrades: Array[UpgradeData] = [
		preload("res://Resources/Upgrades/Type01Upgrade1.tres"),
		preload("res://Resources/Upgrades/Type01Upgrade2.tres"),
		preload("res://Resources/Upgrades/Type01Upgrade3.tres"),
		preload("res://Resources/Upgrades/Type02Upgrade1.tres"),
		preload("res://Resources/Upgrades/Type02Upgrade2.tres"),
		preload("res://Resources/Upgrades/Type02Upgrade3.tres"),
		preload("res://Resources/Upgrades/Type03Upgrade1.tres"),
		preload("res://Resources/Upgrades/Type03Upgrade2.tres"),
		preload("res://Resources/Upgrades/Type03Upgrade3.tres"),
		preload("res://Resources/Upgrades/Type04Upgrade1.tres"),
		preload("res://Resources/Upgrades/Type04Upgrade2.tres"),
		preload("res://Resources/Upgrades/Type04Upgrade3.tres"),
		preload("res://Resources/Upgrades/Type05Upgrade1.tres"),
		preload("res://Resources/Upgrades/Type05Upgrade2.tres"),
		preload("res://Resources/Upgrades/Type05Upgrade3.tres"),
	]

	ShopManager.register_upgrades(upgrades)

	for i in types.size():
		ShopManager.set_base_price(types[i], BUY_PRICES[i])


func get_starting_type() -> EntityData:
	return types[0]


func get_next_type(current: EntityData) -> EntityData:
	var idx := types.find(current)
	if idx == -1 or idx >= types.size() - 1:
		return null
	return types[idx + 1]

extends Node

signal entity_purchased(entity_data: EntityData)
signal shop_unlocked_types_changed()

# Types unlocked by the player (obtained via merge or initial spawn)
var unlocked_types: Array[EntityData] = []

# How many times each type was purchased (scales price)
var purchase_counts: Dictionary = {}

# Purchased upgrades: EntityData -> current_level (int)
var purchased_upgrade_levels: Dictionary = {}

# All upgrades in the game, registered by EntityRegistry
var all_upgrades: Array[UpgradeData] = []

# Base buy prices per type
var _base_buy_prices: Dictionary = {}


func _ready() -> void:
	# Type01 is always unlocked from the start
	unlock_type(EntityRegistry.get_starting_type())


func register_upgrades(upgrades: Array[UpgradeData]) -> void:
	all_upgrades = upgrades


func set_base_price(entity_data: EntityData, price: float) -> void:
	_base_buy_prices[entity_data] = price


func unlock_type(entity_data: EntityData) -> void:
	if entity_data in unlocked_types:
		return
	unlocked_types.append(entity_data)
	shop_unlocked_types_changed.emit()


# --- Buy creatures ---

func get_buy_price(entity_data: EntityData) -> float:
	var base: float = _base_buy_prices.get(entity_data, 15.0)
	var count: int = purchase_counts.get(entity_data, 0)
	return base * pow(1.15, count)


func can_buy_entity(entity_data: EntityData) -> bool:
	return MoneyManager.total_money >= get_buy_price(entity_data)


func buy_entity(entity_data: EntityData) -> bool:
	if not can_buy_entity(entity_data):
		return false
	MoneyManager.total_money -= get_buy_price(entity_data)
	purchase_counts[entity_data] = purchase_counts.get(entity_data, 0) + 1
	entity_purchased.emit(entity_data)
	return true


# --- Upgrades ---

func get_next_upgrade(entity_data: EntityData) -> UpgradeData:
	var current_level: int = purchased_upgrade_levels.get(entity_data, 0)
	for upgrade in all_upgrades:
		if upgrade.entity_data == entity_data and upgrade.level == current_level + 1:
			return upgrade
	return null


func can_buy_upgrade(upgrade: UpgradeData) -> bool:
	return MoneyManager.total_money >= upgrade.cost


func buy_upgrade(upgrade: UpgradeData) -> bool:
	if not can_buy_upgrade(upgrade):
		return false
	MoneyManager.total_money -= upgrade.cost
	purchased_upgrade_levels[upgrade.entity_data] = upgrade.level
	MoneyManager.set_multiplier(upgrade.entity_data, upgrade.multiplier)
	return true

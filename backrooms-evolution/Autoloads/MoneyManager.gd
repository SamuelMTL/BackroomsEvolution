extends Node

var total_money: float = 0.0

# EntityData -> int (count of active entities per type)
var _active_counts: Dictionary = {}

# EntityData -> float (income multiplier, starts at 1.0)
# For future upgrades: set_multiplier(entity_data, new_value)
var _income_multipliers: Dictionary = {}

var _tick_interval: float = 0.1
var _tick_accumulator: float = 0.0


func _process(delta: float) -> void:
	_tick_accumulator += delta
	if _tick_accumulator >= _tick_interval:
		total_money += get_income_per_second() * _tick_accumulator
		_tick_accumulator = 0.0


func register(entity_data: EntityData) -> void:
	_active_counts[entity_data] = _active_counts.get(entity_data, 0) + 1


func unregister(entity_data: EntityData) -> void:
	var count: int = _active_counts.get(entity_data, 0)
	if count <= 1:
		_active_counts.erase(entity_data)
	else:
		_active_counts[entity_data] = count - 1


func get_income_per_second() -> float:
	var total: float = 0.0
	for data in _active_counts:
		total += get_entity_income(data) * _active_counts[data]
	return total


func get_entity_income(entity_data: EntityData) -> float:
	return entity_data.base_income * _income_multipliers.get(entity_data, 1.0)


# Called by future upgrades
func set_multiplier(entity_data: EntityData, multiplier: float) -> void:
	_income_multipliers[entity_data] = multiplier


func format_number(n: float) -> String:
	if n >= 1_000_000:
		return "%.1fM" % (n / 1_000_000.0)
	elif n >= 1_000:
		return "%.1fK" % (n / 1_000.0)
	else:
		return "%.1f" % n

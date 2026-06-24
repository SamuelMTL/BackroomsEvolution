extends CanvasLayer

@onready var label_total: Label = $Panel/VBox/LabelTotal
@onready var label_income: Label = $Panel/VBox/LabelIncome


func _process(_delta: float) -> void:
	label_total.text = "$ %s" % MoneyManager.format_number(MoneyManager.total_money)
	label_income.text = "+%s/s" % MoneyManager.format_number(MoneyManager.get_income_per_second())

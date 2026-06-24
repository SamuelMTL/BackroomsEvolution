extends CanvasLayer

@onready var buy_list: VBoxContainer = $Overlay/Panel/VBox/BuyScroll/BuyList
@onready var upgrade_list: VBoxContainer = $Overlay/Panel/VBox/UpgradeScroll/UpgradeList
@onready var buy_scroll: ScrollContainer = $Overlay/Panel/VBox/BuyScroll
@onready var upgrade_scroll: ScrollContainer = $Overlay/Panel/VBox/UpgradeScroll
@onready var btn_buy_tab: Button = $Overlay/Panel/VBox/TabBar/BtnBuy
@onready var btn_upgrade_tab: Button = $Overlay/Panel/VBox/TabBar/BtnUpgrade


func _ready() -> void:
	ShopManager.shop_unlocked_types_changed.connect(_refresh_buy_tab)
	hide()
	show_buy_tab()


func open() -> void:
	refresh()
	show()


func close() -> void:
	hide()


func refresh() -> void:
	_refresh_buy_tab()
	_refresh_upgrade_tab()


func show_buy_tab() -> void:
	buy_scroll.show()
	upgrade_scroll.hide()
	btn_buy_tab.add_theme_color_override("font_color", Color.WHITE)
	btn_upgrade_tab.remove_theme_color_override("font_color")


func show_upgrade_tab() -> void:
	buy_scroll.hide()
	upgrade_scroll.show()
	btn_upgrade_tab.add_theme_color_override("font_color", Color.WHITE)
	btn_buy_tab.remove_theme_color_override("font_color")


func _refresh_buy_tab() -> void:
	for child in buy_list.get_children():
		child.queue_free()
	for entity_data in ShopManager.unlocked_types:
		buy_list.add_child(_make_buy_card(entity_data))


func _refresh_upgrade_tab() -> void:
	for child in upgrade_list.get_children():
		child.queue_free()
	for entity_data in ShopManager.unlocked_types:
		var upgrade := ShopManager.get_next_upgrade(entity_data)
		if upgrade != null:
			upgrade_list.add_child(_make_upgrade_card(upgrade))


func _make_buy_card(entity_data: EntityData) -> Control:
	var panel := PanelContainer.new()
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 16)
	panel.add_child(hbox)

	var preview := ColorRect.new()
	preview.color = entity_data.color
	preview.custom_minimum_size = Vector2(80, 80)
	hbox.add_child(preview)

	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(info)

	var lbl_name := Label.new()
	lbl_name.text = entity_data.type_name
	lbl_name.add_theme_font_size_override("font_size", 32)
	info.add_child(lbl_name)

	var lbl_income := Label.new()
	lbl_income.text = "+%s/s each" % MoneyManager.format_number(MoneyManager.get_entity_income(entity_data))
	lbl_income.add_theme_font_size_override("font_size", 32)
	lbl_income.add_theme_color_override("font_color", Color(0.6, 1.0, 0.6))
	info.add_child(lbl_income)

	var btn := Button.new()
	btn.custom_minimum_size = Vector2(200, 80)
	btn.add_theme_font_size_override("font_size", 32)
	btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	hbox.add_child(btn)

	var _update_btn = func():
		var price := ShopManager.get_buy_price(entity_data)
		btn.text = "$ %s" % MoneyManager.format_number(price)
		btn.disabled = not ShopManager.can_buy_entity(entity_data)

	_update_btn.call()

	btn.pressed.connect(func():
		if ShopManager.buy_entity(entity_data):
			_update_btn.call()
			_refresh_buy_tab()
	)

	return panel


func _make_upgrade_card(upgrade: UpgradeData) -> Control:
	var panel := PanelContainer.new()
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 16)
	panel.add_child(hbox)

	var preview := ColorRect.new()
	preview.color = upgrade.entity_data.color
	preview.custom_minimum_size = Vector2(80, 80)
	hbox.add_child(preview)

	var info := VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hbox.add_child(info)

	var lbl_name := Label.new()
	lbl_name.text = "%s — Level %d" % [upgrade.entity_data.type_name, upgrade.level]
	lbl_name.add_theme_font_size_override("font_size", 32)
	info.add_child(lbl_name)

	var lbl_desc := Label.new()
	lbl_desc.text = upgrade.description
	lbl_desc.add_theme_font_size_override("font_size", 32)
	lbl_desc.add_theme_color_override("font_color", Color(1.0, 0.9, 0.5))
	info.add_child(lbl_desc)

	var btn := Button.new()
	btn.text = "$ %s" % MoneyManager.format_number(upgrade.cost)
	btn.custom_minimum_size = Vector2(200, 80)
	btn.add_theme_font_size_override("font_size", 32)
	btn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	btn.disabled = not ShopManager.can_buy_upgrade(upgrade)
	hbox.add_child(btn)

	btn.pressed.connect(func():
		if ShopManager.buy_upgrade(upgrade):
			_refresh_upgrade_tab()
	)

	return panel

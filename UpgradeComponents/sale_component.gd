extends Node

var shop: Shop
var slot_types: Array
func _ready() -> void:
	shop = get_parent()
	slot_types = [	shop.default_slots,
					shop.passive_slots,
					shop.bodymod_slots,
					shop.active_slots,
					shop.synergy_slots,
					shop.special_slots
					]
	shop.upgrade_cards_instantiated.connect(_spread_sales)

func _spread_sales():
	var full_categories = 0
	for slot_type in slot_types:
		var is_filled = true
		for slot in slot_type:
			if not shop.is_filled(slot):
				is_filled = false
		if is_filled:
			full_categories += 1
	
	var upgrade_cards: Array[UpgradeCard] = []
	for i in range(3):
		if shop.get_node("ItemShelf").get_child(-i) is UpgradeCard:
			upgrade_cards.append(shop.get_node("ItemShelf").get_child(-i))
		else:
			print("either area or bug")
	
	for sale in range(full_categories):
		upgrade_cards.shuffle()
		for upgrade_card in upgrade_cards:
			if upgrade_card.price > 0:
				upgrade_card.price -= 1
				var sale_label: int = upgrade_card.sale_number.text.to_int()
				sale_label -= 1
				upgrade_card.sale_number.text = str(sale_label)
				upgrade_card.sale_number.get_parent().show()
				break

func self_destruct():
	queue_free()

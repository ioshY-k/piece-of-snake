extends Node

var shop:Shop

func _ready() -> void:
	shop = get_parent().get_parent().shop
	
	var slots_with_bodymods: Array = shop.bodymod_slots.duplicate()
	#add the bodymod in the rainbowslot, if there is one
	if RunSettings.current_char == GameConsts.CHAR_LIST.CHAMELEON and\
	shop.is_filled(shop.rainbow_slots[0]) and\
	shop.rainbow_slots[0].find_child("Area2D").get_child(-1).upgrade_type == GameConsts.UPGRADE_TYPE.BODYMOD:
		slots_with_bodymods.append(shop.rainbow_slots[0])
		
	for slot in slots_with_bodymods:
		for child in slot.get_node("Area2D").get_children():
			if child is UpgradeCard:
				child.destroyed.emit(child.upgrade_id)
				child.queue_free()
	shop.reroll_cost_start_number = 0
	shop.reroll_cost_number = 0
	shop.reroll_cost_label.text = str(shop.reroll_cost_number)
	shop.moulted = true
	shop.deal_new_cards.disabled = false
	var shelf: ItemShelf = shop.get_node("ItemShelf")
	if shelf.get_child(-1) is UpgradeCard:
		shelf.get_child(-1).calculate_price()
	if shelf.get_child(-2) is UpgradeCard:
		shelf.get_child(-2).calculate_price()
	SignalBus.round_started.connect(shop.reset_reroll_cost)

func self_destruct():
	shop.reroll_cost_start_number = 1
	shop.moulted = false
	queue_free()
	

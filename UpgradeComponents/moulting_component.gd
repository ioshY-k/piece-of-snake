extends Node

var shop:Shop

func _ready() -> void:
	shop = get_parent().get_parent().shop
	for slot in shop.bodymod_slots:
		for child in slot.get_node("Area2D").get_children():
			if child is UpgradeCard:
				child.destroyed.emit(child.upgrade_id)
				child.queue_free()
	shop.reroll_cost_start_number = 0
	shop.reroll_cost_number = 0
	shop.reroll_cost_label.text = str(shop.reroll_cost_number)
	shop.moulted = true
	shop.deal_new_cards.disabled = false

func self_destruct():
	shop.reroll_cost_start_number = 1
	shop.moulted = false
	queue_free()
	

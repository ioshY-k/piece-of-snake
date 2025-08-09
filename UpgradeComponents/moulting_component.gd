extends Node

func _ready() -> void:
	var shop:Shop = get_parent().get_parent().shop
	for slot in shop.bodymod_slots:
		for child in slot.get_node("Area2D").get_children():
			if child is UpgradeCard:
				child.destroyed.emit(child.upgrade_id)
				child.queue_free()
	shop.increment_buys(1)

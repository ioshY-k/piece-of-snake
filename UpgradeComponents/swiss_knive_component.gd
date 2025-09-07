extends Node

var shop:Shop

func _ready() -> void:
	shop = get_parent().get_parent().shop
	SignalBus.round_started.connect(_upgrade_bodymods)
	SignalBus.upgrade_bought.connect(_add_swiss_knive_descriptions)
	_add_swiss_knive_descriptions()

func _add_swiss_knive_descriptions(_upgrade_id = 0):
	for bodymod_slot in shop.bodymod_slots:
		if bodymod_slot.find_child("Area2D").get_child(-1) is UpgradeCard:
			var bodymod_upgrade_card: UpgradeCard = bodymod_slot.find_child("Area2D").get_child(-1)
			bodymod_upgrade_card.upgrade_description = bodymod_upgrade_card.swiss_knive_upgrade_descriptions[str(bodymod_upgrade_card.upgrade_id)]

func _remove_swiss_knive_descriptions():
	for bodymod_slot in shop.bodymod_slots:
		if bodymod_slot.find_child("Area2D").get_child(-1) is UpgradeCard:
			var bodymod_upgrade_card: UpgradeCard = bodymod_slot.find_child("Area2D").get_child(-1)
			bodymod_upgrade_card.upgrade_description = bodymod_upgrade_card.upgrade_descriptions[str(bodymod_upgrade_card.upgrade_id)]
	
func _upgrade_bodymods():
	SignalBus.swiss_knive_synergy.emit(true)

func self_destruct():
	SignalBus.swiss_knive_synergy.emit(false)
	_remove_swiss_knive_descriptions()
	queue_free()

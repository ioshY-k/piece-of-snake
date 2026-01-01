extends Node

var shop:Shop
var upgrade_description_original
var upgrade_description_swiss
var card_data

func _ready() -> void:
	shop = get_parent().get_parent().shop
	SignalBus.round_started.connect(_upgrade_bodymods)
	SignalBus.upgrade_bought.connect(_add_swiss_knive_descriptions)
	_add_swiss_knive_descriptions()

func _add_swiss_knive_descriptions(_upgrade_id = 0):
	for bodymod_slot in shop.bodymod_slots:
		if bodymod_slot.find_child("Area2D").get_child(-1) is UpgradeCard:
			var bodymod_upgrade_card: UpgradeCard = bodymod_slot.find_child("Area2D").get_child(-1)
			bodymod_upgrade_card.upgrade_description = TextConsts.get_text(TextConsts.TABLES.CARDS, bodymod_upgrade_card.upgrade_id_string, "SWISSDESC").format({
		"GHOST_FRUIT_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"GHOST_FRUIT_KEYWORD","NAME"),
		"TASTY_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"TASTY_KEYWORD","NAME"),
		"ADVANCEMENT_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"ADVANCEMENT_KEYWORD","NAME"),
		"HOLLOW_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"HOLLOW_KEYWORD","NAME"),
		"DENSE_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"DENSE_KEYWORD","NAME"),
		"PHASING_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"PHASING_KEYWORD","NAME"),
		"SHIELDED_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"SHIELDED_KEYWORD","NAME"),
	})

func _remove_swiss_knive_descriptions():
	for bodymod_slot in shop.bodymod_slots:
		if bodymod_slot.find_child("Area2D").get_child(-1) is UpgradeCard:
			var bodymod_upgrade_card: UpgradeCard = bodymod_slot.find_child("Area2D").get_child(-1)
			bodymod_upgrade_card.upgrade_description = TextConsts.get_text(TextConsts.TABLES.CARDS, bodymod_upgrade_card.upgrade_id_string, "DESC").format({
		"GHOST_FRUIT_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"GHOST_FRUIT_KEYWORD","NAME"),
		"TASTY_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"TASTY_KEYWORD","NAME"),
		"ADVANCEMENT_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"ADVANCEMENT_KEYWORD","NAME"),
		"HOLLOW_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"HOLLOW_KEYWORD","NAME"),
		"DENSE_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"DENSE_KEYWORD","NAME"),
		"PHASING_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"PHASING_KEYWORD","NAME"),
		"SHIELDED_KEYWORD": TextConsts.get_text(TextConsts.TABLES.KEYWORDS,"SHIELDED_KEYWORD","NAME"),
	})
	
func _upgrade_bodymods():
	SignalBus.swiss_knive_synergy.emit(true)

func self_destruct():
	SignalBus.swiss_knive_synergy.emit(false)
	_remove_swiss_knive_descriptions()
	queue_free()

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
	var slots_with_bodymods: Array = shop.bodymod_slots.duplicate()
	#add the bodymod in the rainbowslot, if there is one
	if RunSettings.current_char == GameConsts.CHAR_LIST.CHAMELEON and\
	shop.is_filled(shop.rainbow_slots[0]) and\
	shop.rainbow_slots[0].find_child("Area2D").get_child(-1).upgrade_type == GameConsts.UPGRADE_TYPE.BODYMOD:
		slots_with_bodymods.append(shop.rainbow_slots[0])
		
	for bodymod_slot in slots_with_bodymods:
		if shop.is_filled(bodymod_slot):
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
	var slots_with_bodymods: Array = shop.bodymod_slots.duplicate()
	#add the bodymod in the rainbowslot, if there is one
	if RunSettings.current_char == GameConsts.CHAR_LIST.CHAMELEON and\
	shop.is_filled(shop.rainbow_slots[0]) and\
	shop.rainbow_slots[0].find_child("Area2D").get_child(-1).upgrade_type == GameConsts.UPGRADE_TYPE.BODYMOD:
		slots_with_bodymods.append(shop.rainbow_slots[0])
		
	for bodymod_slot in slots_with_bodymods:
		if shop.is_filled(bodymod_slot):
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

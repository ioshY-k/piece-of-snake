extends Node

@onready var shop:Shop = get_parent()
var upgrade_card_scene = load("res://Shop/UpgradeCards/upgrade_card.tscn")
var passive_dead_mice: Array[UpgradeCard] = []
var bodymod_dead_mice: Array[UpgradeCard] = []
var synergy_dead_mice: Array[UpgradeCard] = []
var active_dead_mice: Array[UpgradeCard] = []
@onready var all_slots: Array = [shop.passive_slots, shop.bodymod_slots, shop.synergy_slots, shop.active_slots]

func _ready():
	for slot_type in all_slots:
		for slot in slot_type:
			if slot.find_child("Area2D").get_child(-1) is UpgradeCard:
				continue
			var dead_mouse: UpgradeCard = upgrade_card_scene.instantiate()
			slot.find_child("Area2D").add_child(dead_mouse)
			dead_mouse.owned_slot_area = slot.find_child("Area2D")
			dead_mouse.is_bought = true
			dead_mouse.card_sprite.frame = 65
			dead_mouse.upgrade_id = GameConsts.UPGRADE_LIST.DEAD_MOUSE
			var x_offset = randi_range(-300,300)
			var y_offset = randi_range(-300,300)
			dead_mouse.position += Vector2(x_offset,y_offset)
			dead_mouse._snap_to_slot(slot.find_child("Area2D"))
			match slot.get_groups():
				["Slot Passive"]:
					passive_dead_mice.append(dead_mouse)
				["Slot Bodymod"]:
					bodymod_dead_mice.append(dead_mouse)
				["Slot Synergy"]:
					synergy_dead_mice.append(dead_mouse)
				["Slot Active"]:
					active_dead_mice.append(dead_mouse)
	SignalBus.upgrade_bought.connect(_random_item_on_area_size)

func _random_item_on_area_size(upgrade_id):
	if upgrade_id == GameConsts.UPGRADE_LIST.AREA_SIZE_1 or\
	upgrade_id == GameConsts.UPGRADE_LIST.AREA_SIZE_2 or\
	upgrade_id == GameConsts.UPGRADE_LIST.AREA_SIZE_3:
		all_slots.shuffle()
		var slot_found = false
		var replaced_dead_mouse: UpgradeCard = null
		for slot_type in all_slots:
			if slot_found:
				break
			for slot in slot_type:
				if not slot_found and slot.find_child("Area2D").get_child(-1) is UpgradeCard and\
				slot.find_child("Area2D").get_child(-1).upgrade_id == GameConsts.UPGRADE_LIST.DEAD_MOUSE:
					slot_found = true
					slot.find_child("Area2D").get_child(-1).queue_free()
					
					var random_upgrade_id
					match slot_type:
						shop.passive_slots:
							random_upgrade_id = shop.select_random_upgrade(GameConsts.UPGRADE_TYPE.PASSIVE)
						shop.bodymod_slots:
							random_upgrade_id = shop.select_random_upgrade(GameConsts.UPGRADE_TYPE.BODYMOD)
						shop.synergy_slots:
							random_upgrade_id = shop.select_random_upgrade(GameConsts.UPGRADE_TYPE.SYNERGY)
						shop.active_slots:
							random_upgrade_id = shop.select_random_upgrade(GameConsts.UPGRADE_TYPE.ACTIVE)
					
					var upgrade_card: UpgradeCard = upgrade_card_scene.instantiate()
					slot.get_node("Area2D").add_child(upgrade_card)
					upgrade_card.instantiate_upgrade_card(random_upgrade_id)
					upgrade_card.is_bought = true
					upgrade_card.owned_slot_area = slot.get_node("Area2D")
					await get_tree().process_frame
					upgrade_card._snap_to_slot(slot.get_node("Area2D"))
					shop.update_upgrade_pool(random_upgrade_id, true)
					SignalBus.upgrade_bought.emit(random_upgrade_id)
					break

func self_destruct():
	queue_free()

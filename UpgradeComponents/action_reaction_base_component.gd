class_name ActionReactionBase extends Node

var level: LevelManager
var slot_index: int
var upgrade_id: int

func _ready() -> void:
	level = get_parent()
	var shop:Shop = level.get_parent().get_node("Shop")
	for passive_slot_index in range(shop.passive_slots.size()):
		if shop.passive_slots[passive_slot_index].get_node("Area2D").get_child(-1) is UpgradeCard and\
		shop.passive_slots[passive_slot_index].get_node("Area2D").get_child(-1).upgrade_id == upgrade_id:
			slot_index = passive_slot_index
			break

func emit_action_trigger_signal():
	SignalBus.action_triggered.emit(slot_index)

func self_destruct():
	queue_free()

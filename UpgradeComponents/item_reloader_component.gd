extends Node
var original_drain_speed: int

func _ready() -> void:
	SignalBus.fruit_collected.connect(_on_fruit_collected)

func _on_fruit_collected(_element):
	print("check battery")
	if get_parent().fruits_left == 0 and get_parent().fruits_overload == 0:
		for active_item_slot in get_parent().active_item_slots:
			if active_item_slot.get_child_count() != 1:
				active_item_slot.refresh_lights()

func self_destruct():
	queue_free()

class_name Shop extends CanvasLayer

signal upgrade_bought
signal finished_buying

var available_upgrades: Array[PackedScene] = [	load("res://UpgradeComponents/fruit_magnet_1_component.tscn"),
												load("res://UpgradeComponents/fruit_relocator_1_component.tscn")]

func _on_upgrade_card_bought(upgrade_id: int) -> void:
	print("shop recieved")
	upgrade_bought.emit(upgrade_id)


func _on_continue_next_round_pressed() -> void:
	finished_buying.emit()

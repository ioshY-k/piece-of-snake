class_name Shop extends CanvasLayer

signal upgrade_chosen

func _on_upgrade_pressed() -> void:
	upgrade_chosen.emit()

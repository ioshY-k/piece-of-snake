extends Button

func _on_pressed() -> void:
	GlobalSettings.reset_masteries()
	get_tree().reload_current_scene()

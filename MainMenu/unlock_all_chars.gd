extends Button

func _on_pressed() -> void:
	GlobalSettings.unlock_all_characters()
	get_tree().reload_current_scene()

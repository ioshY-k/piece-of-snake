extends Button


func _on_pressed() -> void:
	GlobalSettings.reset_character_unlocks()
	get_tree().reload_current_scene()

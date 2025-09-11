extends Node2D


func _on_new_run_button_pressed() -> void:
	get_node("/root/MainSceneLoader").change_scene("MAIN_MENU")


func _on_quit_button_pressed() -> void:
	get_tree().quit()

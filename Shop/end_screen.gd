extends Node2D

func _ready() -> void:
	visibility_changed.connect(update_code)

func _on_new_run_button_pressed() -> void:
	get_node("/root/MainSceneLoader").change_scene("MAIN_MENU")
	RunHistoryCodeManager.reset_code()


func _on_quit_button_pressed() -> void:
	get_tree().quit()

func update_code():
	$Code.text = RunHistoryCodeManager.codestring

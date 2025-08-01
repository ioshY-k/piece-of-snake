extends Node2D

var scene_loader: SceneLoader

func _ready() -> void:
	scene_loader = get_parent()

func _on_new_run_pressed() -> void:
	scene_loader.change_scene("RUN_MANAGER")

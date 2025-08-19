extends Node2D


var scene_loader: SceneLoader
@onready var character_selection: Node2D = $CharacterSelection

func _ready() -> void:
	scene_loader = get_parent()
	character_selection.char_changed.connect(_on_char_changed)

func _on_char_changed(char_id: int):
	RunSettings.current_char = char_id

func _on_new_run_pressed() -> void:
	scene_loader.change_scene("RUN_MANAGER")

class_name SceneLoader extends Node

const RUN_MANAGER = preload("res://RunHandler/run_manager.tscn")
const MAIN_MENU = preload("res://MainMenu/main_menu.tscn")
const INTRO_SCREEN = preload("res://Shop/intro_screen.tscn")

func _ready() -> void:
	change_scene("MAIN_MENU")
	#var intro = INTRO_SCREEN.instantiate()
	#add_child(intro)
	

func change_scene(scene: String):
	for child in get_children():
		child.queue_free()
	match scene:
		"RUN_MANAGER":
			var new_scene = RUN_MANAGER.instantiate()
			add_child(new_scene)
		"MAIN_MENU":
			var new_scene = MAIN_MENU.instantiate()
			add_child(new_scene)
	

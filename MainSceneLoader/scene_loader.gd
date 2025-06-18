extends Node

const RUN_MANAGER = preload("res://RunHandler/run_manager.tscn")

func _ready() -> void:
	var run_manager = RUN_MANAGER.instantiate()
	add_child(run_manager)

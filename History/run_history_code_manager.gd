extends Node

var save_path = "user://savegame.dat"

func _ready() -> void:
	var data = "teststring"
	save_game(data)

func save_game(data: Dictionary):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)  # stores dictionary, array, numbers, etc.
	file.close()

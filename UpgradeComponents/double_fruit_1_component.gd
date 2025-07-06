extends Node

func _ready():
	var forbidden_tiles : Array[Vector2i] = []
	get_parent().spawn_fruit(forbidden_tiles)

func self_destruct():
	get_parent().find_all_fruits()[0].queue_free()
	queue_free()

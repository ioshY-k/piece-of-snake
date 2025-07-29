extends Node

var map: Map

func _ready() -> void:
	SignalBus.next_tile_reached.connect(convert_corner_to_overlap)
	map = get_parent()

func convert_corner_to_overlap():
	if map.snake_path_bodyparts[-1].is_corner:
		map.snake_path_bodyparts[-1].set_overlap(true)

func self_destruct():
	queue_free()

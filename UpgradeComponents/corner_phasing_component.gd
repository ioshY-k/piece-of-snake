extends Node

var swiss_knive = false
var map: Map

func _ready() -> void:
	SignalBus.next_tile_reached.connect(convert_corner_to_overlap)
	SignalBus.swiss_knive_synergy.connect(_set_swiss_knive)
	map = get_parent()

func _set_swiss_knive(state:bool):
	swiss_knive = state
	
func convert_corner_to_overlap():
	if map.snake_path_bodyparts[-1].is_corner:
		map.snake_path_bodyparts[-1].set_overlap(true, false)
		

func self_destruct():
	queue_free()

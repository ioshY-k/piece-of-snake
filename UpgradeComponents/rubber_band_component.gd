extends Node

var swiss_knive = false
var map:Map
var straights_in_succession: int = 0
var invincibility_length: int = 4

func _ready() -> void:
	map = get_parent()
	SignalBus.next_tile_reached.connect(_count_straight_bodyparts)
	map.snake_head.rubber.connect(_turn_invincible)
	SignalBus.swiss_knive_synergy.connect(_set_swiss_knive)

func _set_swiss_knive(state:bool):
	print("knived")
	swiss_knive = state
	if swiss_knive:
		invincibility_length = 8
	else:
		invincibility_length = 4

func _count_straight_bodyparts():
	if not map.snake_path_bodyparts[-1].is_corner:
		straights_in_succession += 1
	else:
		straights_in_succession = 0
		
	if straights_in_succession >= 5 and map.snake_path_bodyparts.size() >= 5:
		map.snake_path_bodyparts[-3].turn_rubber()

func _turn_invincible():
	map.invincible_ticks = invincibility_length

func self_destruct():
	queue_free()

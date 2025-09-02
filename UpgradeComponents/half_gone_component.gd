extends Node

var map:Map
var is_half_gone: bool = false
@onready var half_gone_timer: Timer = $HalfGoneTimer

func _ready() -> void:
	map = get_parent()
	SignalBus.fruit_collected.connect(_additional_grow)
	SignalBus.next_tile_reached.connect(_make_transparent)
	half_gone_timer.timeout.connect(_make_solid)

func _additional_grow(fruit, real_collection):
	is_half_gone = true
	half_gone_timer.start()
	map.snake_tail.tiles_to_grow += 1

func _make_transparent():
	if not map.snake_path_bodyparts[-1].is_overlap_bodypart and is_half_gone:
		map.snake_path_bodyparts[-1].set_overlap(true, true)
	if map.snake_path_bodyparts[map.snake_path_bodyparts.size()/2].is_reverted_on_half:
		map.snake_path_bodyparts[map.snake_path_bodyparts.size()/2].set_overlap(false, false)

func _make_solid():
	is_half_gone = false
	for bodypart in map.snake_path_bodyparts:
		if bodypart.is_reverted_on_half:
			bodypart.set_overlap(false,false)

func self_destruct():
	_make_solid()
	queue_free()

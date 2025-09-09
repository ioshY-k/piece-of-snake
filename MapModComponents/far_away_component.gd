extends Node

var map:Map
var close_tiles: Array[Vector2i] = []
var fruit_counter: int = 0
const EFFECT_TRIGGER_TEXT = preload("res://UI/effect_trigger_text.tscn")

func _ready() -> void:
	map = get_parent()
	SignalBus.pre_next_tile_reached.connect(_more_distance)
	SignalBus.next_tile_reached.connect(_reset)
	SignalBus.fruit_collected.connect(_extra_point)

func _more_distance():
	var snake_head_tile = TileHelper.position_to_tile(map.snake_head.position)
	var x = snake_head_tile.x - 7
	var y = snake_head_tile.y -7
	while x <= snake_head_tile.x + 7:
		while y <= snake_head_tile.y + 7:
			close_tiles.append(Vector2i(x,y))
			y += 1
		x += 1
		y = snake_head_tile.y - 7
	map.temporary_obstacles.append_array(close_tiles)

func _reset():
	for close_tile in close_tiles:
		map.temporary_obstacles.erase(close_tile)
	close_tiles = []

func _extra_point(_fruit, is_real_collection):
	if not is_real_collection:
		return
	if fruit_counter%2 == 0:
		map.snake_tail.tiles_to_grow += 1
		var dense_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
		dense_trigger_text.initialize(dense_trigger_text.EFFECTS.DENSE)
		map.add_child(dense_trigger_text)
		SignalBus.fruit_collected.emit(null, false)
		var tast_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
		tast_trigger_text.initialize(tast_trigger_text.EFFECTS.BONUS_FRUIT)
		map.add_child(tast_trigger_text)
	fruit_counter += 1

func self_destruct():
	queue_free()

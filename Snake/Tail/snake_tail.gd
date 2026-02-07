class_name SnakeTail extends MovingSnakePart

var tiles_to_grow = 0

var snake_head: MovingSnakePart
var teleport_destination = null
var snek_shrinking: bool = false

func _ready() -> void:
	super._ready()

func _on_next_tile_reached():
	if TileHelper.position_to_tile(position) != TileHelper.position_to_tile(map.snake_path_bodyparts[0].position):
		position = map.snake_path_bodyparts[0].position
		next_tile = TileHelper.position_to_tile(position)
	if TileHelper.position_to_tile(map.snake_path_bodyparts[1].position) != TileHelper.get_next_tile(TileHelper.position_to_tile(position),map.snake_path_directions[0]):
		position = TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(map.snake_path_bodyparts[1].position),TileHelper.get_opposite(map.snake_path_directions[0])))
		next_tile = TileHelper.position_to_tile(position)
		SignalBus.tail_teleported.emit()
	#when not growing, delete last snake body and direction path, then follow given direction
	if (tiles_to_grow == 0 and snake_head.moves) or snek_shrinking:
		current_tile = next_tile
		map.pop_snake_bodyparts()
		current_direction = map.pop_snake_directions()

		next_tile = TileHelper.get_next_tile(current_tile, current_direction)
	#otherwise stand still and grow
	elif snake_head.moves and tiles_to_grow > 0:
		tiles_to_grow -= 1
		SignalBus.tail_grows.emit()

	get_moving_tween(true)
	get_turning_tween(map.snake_path_directions[0])
	
	SignalBus.continue_moving.emit(snake_head.current_direction)

func delayed_regrow_tiles(seconds: int, tiles: int):
	await get_tree().create_timer(seconds).timeout
	tiles_to_grow += tiles
	while tiles > 0:
		SignalBus.tail_grows.emit()
		tiles -= 1

func check_moves():
	return snake_head.moves
func _on_stop_moving(_tail_moves):
	pass
func _on_continue_moving(current_direction):
	pass

class_name SnakeTail extends MovingSnakePart

var tiles_to_grow = 0

var snake_head: MovingSnakePart
var teleport_destination = null
var snek_shrinking: bool = false

func _ready() -> void:
	super._ready()
	SignalBus.teleported.connect(_on_teleported)

func _on_next_tile_reached():
	if TileHelper.position_to_tile(position) != TileHelper.position_to_tile(map.snake_path_bodyparts[0].position):
		position = map.snake_path_bodyparts[0].position
		next_tile = TileHelper.position_to_tile(position)
		
	
	#position can only be changed in this method, cause tweens override it otherwise
	if teleport_destination != null:
		position = TileHelper.tile_to_position(teleport_destination)
		next_tile = teleport_destination
		teleport_destination = null
		
	#when not growing, delete last snake body and direction path, then follow given direction
	if (tiles_to_grow == 0 and snake_head.moves) or snek_shrinking:
		current_tile = next_tile
		map.pop_snake_bodyparts()
		current_direction = map.pop_snake_directions()
		next_tile = TileHelper.get_next_tile(current_tile, current_direction)
	#otherwise stand still and grow
	elif snake_head.moves:
		tiles_to_grow -= 1
		SignalBus.tail_grows.emit()

	get_moving_tween(true)
	get_turning_tween(map.snake_path_directions[0])
	
	SignalBus.continue_moving.emit(snake_head.current_direction)

func _on_teleported(teleporter: Teleporter):
	return
	var destination = teleporter.destination_tile
	var countdown: TailCountdown = TailCountdown.new(get_parent().snake_path_bodyparts.size())
	await countdown.countdown_reached
	teleport_destination = destination
	SignalBus.teleport_finished.emit(teleporter)

func _on_stop_moving(_tail_moves):
	pass
func _on_continue_moving(current_direction):
	pass
func check_moves():
	return snake_head.moves

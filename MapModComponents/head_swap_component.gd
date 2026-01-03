extends Node

var map: Map
var head:SnakeHead
var tail:SnakeTail

func _ready() -> void:
	map = get_parent()
	head = map.snake_head
	tail = map.snake_tail
	SignalBus.fruit_collected.connect(swap_head)

func swap_head(_element, is_real_collection):
	if not is_real_collection:
		return
	await SignalBus.next_tile_reached
	
	map.snake_path_bodyparts.reverse()
	map.snake_path_directions.reverse()
	for index in range(map.snake_path_directions.size()):
		map.snake_path_directions[index] = TileHelper.get_opposite(map.snake_path_directions[index])
	map.snake_path_directions.pop_front()
	map.snake_path_directions.push_back(map.DIRECTION.STOP)
	for body: SnakeBody in map.snake_path_bodyparts:
		body.flip_rotation()
	
	head.position = TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(tail.position),tail.current_direction))
	
	head.current_direction = TileHelper.get_opposite(tail.current_direction)
	head.current_tile = TileHelper.position_to_tile(head.position)
	head.next_tile = TileHelper.get_next_tile(head.current_tile, head.current_direction)
	
	await SignalBus.next_tile_reached
	
	map.snake_path_bodyparts[-1].modulate = Color(1.0, 0.0, 1.0)
	

func self_destruct():
	queue_free()

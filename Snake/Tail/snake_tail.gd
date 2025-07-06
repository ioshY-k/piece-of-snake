class_name SnakeTail extends MovingSnakePart

var tiles_to_grow = 0

var snake_head: MovingSnakePart


func _on_next_tile_reached():
	#when not growing, delete last snake body and direction path, then follow given direction
	if tiles_to_grow == 0 and snake_head.moves:
		current_tile = next_tile
		map.pop_snake_bodyparts()
		current_direction = map.pop_snake_directions()
		next_tile = map.get_next_tile(next_tile, current_direction)
	#otherwise stand still
	elif snake_head.moves:
		tiles_to_grow -= 1
	
	
	
	get_moving_tween(true)
	get_turning_tween(current_direction)
	
	snake_head.moves = true
	
	

class_name SnakeTail extends MovingSnakePart

var tiles_to_grow = 0

func _on_next_tile_reached():
	#when not growing, delete last snake body and direction path, then follow given direction
	if tiles_to_grow == 0:
		current_tile = next_tile
		map.pop_snake_bodyparts()
		current_direction = map.pop_snake_directions()
		next_tile = map.get_next_tile(next_tile, current_direction)
	#otherwise stand still
	else:
		tiles_to_grow -= 1
	
	get_moving_tween()
	get_turning_tween(current_direction)
	
	

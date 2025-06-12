class_name Tail extends MovingSnakePart


func _on_next_tile_reached():
	current_tile = next_tile
	map.delete_snake_body()
	current_direction = map.pop_snake_path_directions()
	next_tile = map.get_next_tile(next_tile, current_direction)
	
	moving_tween = get_moving_tween()
	turning_tween = get_turning_tween()
	

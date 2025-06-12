class_name Snake extends MovingSnakePart







func _on_next_tile_reached():
	current_tile = next_tile
	
	map.place_snake_body(current_tile)
	map.push_snake_path_directions(current_direction)
	map.push_snake_path_bodyparts()
	
	
	if Input.is_action_pressed("move_up"):
		next_tile = map.get_next_tile(next_tile, DIRECTION.UP)
		current_direction = DIRECTION.UP
	elif Input.is_action_pressed("move_right"):
		next_tile = map.get_next_tile(next_tile, DIRECTION.RIGHT)
		current_direction = DIRECTION.RIGHT
	elif Input.is_action_pressed("move_down"):
		next_tile = map.get_next_tile(next_tile, DIRECTION.DOWN)
		current_direction = DIRECTION.DOWN
	elif Input.is_action_pressed("move_left"):
		next_tile = map.get_next_tile(next_tile, DIRECTION.LEFT)
		current_direction = DIRECTION.LEFT
	else:
		next_tile = map.get_next_tile(next_tile, current_direction)
	
	moving_tween = get_moving_tween()
	turning_tween = get_turning_tween()
	

class_name Snake extends MovingSnakePart

@onready var front_collision_ray: RayCast2D = $FrontCollisionRay
@onready var right_collision_ray: RayCast2D = $RightCollisionRay
@onready var left_collision_ray: RayCast2D = $LeftCollisionRay


var colliding_element: MapElement




func _on_next_tile_reached():
	current_tile = next_tile
	
	map.place_snake_body(current_tile)
	map.push_snake_path_directions(current_direction)
	map.push_snake_path_bodyparts()
	
	
	if Input.is_action_pressed("move_up") and current_direction != DIRECTION.DOWN:
		next_tile = map.get_next_tile(next_tile, DIRECTION.UP)
		colliding_element = check_upcoming_collision(current_direction, DIRECTION.UP)
		current_direction = DIRECTION.UP
	elif Input.is_action_pressed("move_right") and current_direction != DIRECTION.LEFT:
		next_tile = map.get_next_tile(next_tile, DIRECTION.RIGHT)
		colliding_element = check_upcoming_collision(current_direction, DIRECTION.RIGHT)
		current_direction = DIRECTION.RIGHT
	elif Input.is_action_pressed("move_down") and current_direction != DIRECTION.UP:
		next_tile = map.get_next_tile(next_tile, DIRECTION.DOWN)
		colliding_element = check_upcoming_collision(current_direction, DIRECTION.DOWN)
		current_direction = DIRECTION.DOWN
	elif Input.is_action_pressed("move_left") and current_direction != DIRECTION.RIGHT:
		next_tile = map.get_next_tile(next_tile, DIRECTION.LEFT)
		colliding_element = check_upcoming_collision(current_direction, DIRECTION.LEFT)
		current_direction = DIRECTION.LEFT
	else:
		next_tile = map.get_next_tile(next_tile, current_direction)
		colliding_element = check_upcoming_collision(current_direction, current_direction)
	
	if colliding_element == null:
		moving_tween = get_moving_tween()
		turning_tween = get_turning_tween()
		return
	if colliding_element.collision_layer == 1:#Solid
		get_tree().reload_current_scene()
		return
	if colliding_element.collision_layer == 2:#Fruit
		colliding_element.collision_with.emit()
		
		
	
	moving_tween = get_moving_tween()
	turning_tween = get_turning_tween()
	
func check_upcoming_collision(current_dir, next_dir) -> MapElement:
	match current_dir:
		DIRECTION.UP:
			match next_dir:
				DIRECTION.UP:
					return front_collision_ray.get_collider()
				DIRECTION.RIGHT:
					return right_collision_ray.get_collider()
				DIRECTION.LEFT:
					return left_collision_ray.get_collider()
		DIRECTION.RIGHT:
			match next_dir:
				DIRECTION.UP:
					return left_collision_ray.get_collider()
				DIRECTION.RIGHT:
					return front_collision_ray.get_collider()
				DIRECTION.DOWN:
					return right_collision_ray.get_collider()
		DIRECTION.DOWN:
			match next_dir:
				DIRECTION.RIGHT:
					return left_collision_ray.get_collider()
				DIRECTION.DOWN:
					return front_collision_ray.get_collider()
				DIRECTION.LEFT:
					return right_collision_ray.get_collider()
		DIRECTION.LEFT:
			match next_dir:
				DIRECTION.UP:
					return right_collision_ray.get_collider()
				DIRECTION.DOWN:
					return left_collision_ray.get_collider()
				DIRECTION.LEFT:
					return front_collision_ray.get_collider()
	print_debug("no direction found")
	return null
			

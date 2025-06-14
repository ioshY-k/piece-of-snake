class_name SnakeHead extends MovingSnakePart

@onready var front_collision_ray: RayCast2D = $FrontCollisionRay
@onready var right_collision_ray: RayCast2D = $RightCollisionRay
@onready var left_collision_ray: RayCast2D = $LeftCollisionRay


var colliding_element: MapElement
var buffered_input_direction: int

func _process(delta: float) -> void:
	buffer_last_input_direction()


func _on_next_tile_reached():
	current_tile = next_tile
	
	map.push_snake_directions(current_direction)
	
	
	if (Input.is_action_pressed("move_up") or buffered_input_direction == DIRECTION.UP) and current_direction != DIRECTION.DOWN:
		next_tile = map.get_next_tile(next_tile, DIRECTION.UP)
		colliding_element = check_upcoming_collision(current_direction, DIRECTION.UP)
		current_direction = DIRECTION.UP
	elif (Input.is_action_pressed("move_right") or buffered_input_direction == DIRECTION.RIGHT) and current_direction != DIRECTION.LEFT:
		next_tile = map.get_next_tile(next_tile, DIRECTION.RIGHT)
		colliding_element = check_upcoming_collision(current_direction, DIRECTION.RIGHT)
		current_direction = DIRECTION.RIGHT
	elif (Input.is_action_pressed("move_down") or buffered_input_direction == DIRECTION.DOWN) and current_direction != DIRECTION.UP:
		next_tile = map.get_next_tile(next_tile, DIRECTION.DOWN)
		colliding_element = check_upcoming_collision(current_direction, DIRECTION.DOWN)
		current_direction = DIRECTION.DOWN
	elif (Input.is_action_pressed("move_left") or buffered_input_direction == DIRECTION.LEFT) and current_direction != DIRECTION.RIGHT:
		next_tile = map.get_next_tile(next_tile, DIRECTION.LEFT)
		colliding_element = check_upcoming_collision(current_direction, DIRECTION.LEFT)
		current_direction = DIRECTION.LEFT
	else:
		next_tile = map.get_next_tile(next_tile, current_direction)
		colliding_element = check_upcoming_collision(current_direction, current_direction)
	
	map.push_snake_bodyparts(current_tile, current_direction)
		
	#unreachable value
	buffered_input_direction = -10
	
	if colliding_element == null:
		moving_tween = get_moving_tween()
		turning_tween = get_turning_tween(current_direction)
		return
	if colliding_element.collision_layer == 1:#Solid
		get_tree().reload_current_scene()
		return
	if colliding_element.collision_layer == 2:#Fruit
		colliding_element.collision_with.emit()

	moving_tween = get_moving_tween()
	turning_tween = get_turning_tween(current_direction)
	
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

#region helper functions
func buffer_last_input_direction():
	var current_input_direction = buffered_input_direction
	if Input.is_action_just_pressed("move_up"):
		buffered_input_direction = DIRECTION.UP
	if Input.is_action_just_pressed("move_right"):
		buffered_input_direction = DIRECTION.RIGHT
	if Input.is_action_just_pressed("move_down"):
		buffered_input_direction = DIRECTION.DOWN
	if Input.is_action_just_pressed("move_left"):
		buffered_input_direction = DIRECTION.LEFT
	if current_input_direction != buffered_input_direction or buffered_input_direction == -10:
		determine_frame_from_orientation(buffered_input_direction)

func determine_frame_from_orientation(buffered_input_direction):
	if 	buffered_input_direction == current_direction+1 or buffered_input_direction == current_direction-3:
		frame = 2
	if 	buffered_input_direction == current_direction-1 or buffered_input_direction == current_direction+3:
		frame = 1
	elif buffered_input_direction == current_direction or buffered_input_direction == -10:
		frame = 0
#endregion

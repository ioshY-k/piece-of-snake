class_name SnakeHead extends MovingSnakePart

@onready var front_collision_ray: RayCast2D = $FrontCollisionRay
@onready var right_collision_ray: RayCast2D = $RightCollisionRay
@onready var left_collision_ray: RayCast2D = $LeftCollisionRay
var snake_tail: MovingSnakePart

signal got_hit

var colliding_element: MapElement
var buffered_input_direction: int
var moves: bool = true
var push_overlap_bodypart: bool = false

#to store the direction in case of teleportation where it is still relevant but got overwritten
var original_direction: int

func _process(delta: float) -> void:
	#print(moves)
	buffer_last_input_direction()

func _on_next_tile_reached():
	original_direction = current_direction
	current_tile = next_tile
	
	if (Input.is_action_pressed("move_up") or buffered_input_direction == DIRECTION.UP) and current_direction != DIRECTION.DOWN:
		next_tile = TileHelper.get_next_tile(current_tile, DIRECTION.UP)
		colliding_element = check_upcoming_collision(current_direction, DIRECTION.UP)
		current_direction = DIRECTION.UP
	elif (Input.is_action_pressed("move_right") or buffered_input_direction == DIRECTION.RIGHT) and current_direction != DIRECTION.LEFT:
		next_tile = TileHelper.get_next_tile(current_tile, DIRECTION.RIGHT)
		colliding_element = check_upcoming_collision(current_direction, DIRECTION.RIGHT)
		current_direction = DIRECTION.RIGHT
	elif (Input.is_action_pressed("move_down") or buffered_input_direction == DIRECTION.DOWN) and current_direction != DIRECTION.UP:
		next_tile = TileHelper.get_next_tile(current_tile, DIRECTION.DOWN)
		colliding_element = check_upcoming_collision(current_direction, DIRECTION.DOWN)
		current_direction = DIRECTION.DOWN
	elif (Input.is_action_pressed("move_left") or buffered_input_direction == DIRECTION.LEFT) and current_direction != DIRECTION.RIGHT:
		next_tile = TileHelper.get_next_tile(current_tile, DIRECTION.LEFT)
		colliding_element = check_upcoming_collision(current_direction, DIRECTION.LEFT)
		current_direction = DIRECTION.LEFT
	else:
		next_tile = TileHelper.get_next_tile(current_tile, current_direction)
		colliding_element = check_upcoming_collision(current_direction, current_direction)
	
		
	#reset buffer to unreachable value
	buffered_input_direction = -10
	
	SignalBus.pre_next_tile_reached.emit()
	
	if colliding_element != null and colliding_element.get_collision_layer_value(5):#Teleporter
		var temp_next_tile = next_tile
		var temp_position = position
		var temp_teleporter = colliding_element
		
		position = TileHelper.tile_to_position(colliding_element.destination_tile)
		next_tile = TileHelper.get_next_tile(colliding_element.destination_tile, current_direction)
		colliding_element = check_upcoming_collision(original_direction, current_direction)
		if colliding_element != null and colliding_element.is_in_group("Wall"):
			var temp_colliding_element = colliding_element
			colliding_element.set_collision_layer_value(1,false)
			colliding_element = check_upcoming_collision(original_direction, current_direction)
			temp_colliding_element.set_collision_layer_value(1,true)
			
			
		if colliding_element != null and colliding_element.get_collision_layer_value(1):#SolidAfterTeleport
			next_tile = temp_next_tile
			position = temp_position
		else:
			SignalBus.teleported.emit(temp_teleporter)
		
	if colliding_element == null:
		pass
	elif colliding_element.get_collision_layer_value(1) or\
		colliding_element.get_collision_layer_value(6): #Solid or Obstacle
		SignalBus.stop_moving.emit()
		got_hit.emit()
	elif colliding_element.get_collision_layer_value(2) :#Fruit
		colliding_element.collision_with.emit()
	elif colliding_element.get_collision_layer_value(7) :#Overlap
		colliding_element.snake_overlapped.emit()
	
	if not moves:
		next_tile = current_tile
	else:
		map.push_snake_bodyparts(current_tile, current_direction, push_overlap_bodypart)
		map.push_snake_directions(current_direction)
	
	#same check after the body was pushed, since it is the body after that, which needs to Overlap in overlap cases
	if colliding_element != null and colliding_element.get_collision_layer_value(7) :#Overlap
		push_overlap_bodypart = true
		
	
	SignalBus.next_tile_reached.emit()
	
	get_moving_tween(moves)
	get_turning_tween(current_direction)

func _on_stop_moving():
	moves = false
func _on_continue_moving():
	moves = true
	
func check_upcoming_collision(current_dir, next_dir) -> MapElement:
	front_collision_ray.force_raycast_update()
	right_collision_ray.force_raycast_update()
	left_collision_ray.force_raycast_update()
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

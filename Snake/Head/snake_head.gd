class_name SnakeHead extends MovingSnakePart



@onready var front_collision_ray: RayCast2D = $FrontCollisionRay
@onready var right_collision_ray: RayCast2D = $RightCollisionRay
@onready var left_collision_ray: RayCast2D = $LeftCollisionRay
@onready var fruit_collect_area: Area2D = $FruitCollectArea

var snake_tail: MovingSnakePart

#when passing special bodyparts
signal cut
signal rubber

var colliding_element: MapElement
var buffered_input_direction: int = -10
var second_buffered_input_direction: int = -10
var moves: bool = true
var just_teleported: bool = false
var push_overlap_bodypart: bool = false
var hit_signal_muted: bool = false

#to store the direction in case of teleportation where it is still relevant but got overwritten
var original_direction: int

func _process(delta: float) -> void:
	buffer_last_input_direction()
	if fruit_collect_area.has_overlapping_areas():
		for fruit in fruit_collect_area.get_overlapping_areas():
			if not fruit.collected:
				fruit.collision_with.emit(fruit, position)


var last_call_time: int = 0
func _on_next_tile_reached():
	
	var now = Time.get_ticks_msec()

	if last_call_time != 0:
		var elapsed_ms = now - last_call_time
		#print("Zeit seit letztem Aufruf: ", elapsed_ms, " ms (", elapsed_ms / 1000.0, " s)")
		
	last_call_time = now
	
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
		var index = -2
		while current_direction == 4:
			print_debug("theres 4 as current direction. should only happen in headswap mode")
			current_direction = map.snake_path_directions[index]
			index -= 1
		next_tile = TileHelper.get_next_tile(current_tile, current_direction)
		colliding_element = check_upcoming_collision(current_direction, current_direction)
		
	#prevent snake from turning into a wall
	if  original_direction != current_direction and colliding_element != null and\
	(colliding_element.get_collision_layer_value(1) or colliding_element.get_collision_layer_value(6)) and\
	!colliding_element.get_collision_layer_value(10):
		next_tile = TileHelper.get_next_tile(current_tile, original_direction)
		colliding_element = check_upcoming_collision(original_direction, original_direction)
		current_direction = original_direction
		SignalBus.stop_moving.emit(false)
		if not hit_signal_muted:
			SignalBus.got_hit.emit()
	
	SignalBus.pre_next_tile_reached.emit()
	
	#reset buffer to unreachable value
	if second_buffered_input_direction != -10:
		buffered_input_direction = second_buffered_input_direction
		second_buffered_input_direction = -10
	else:
		buffered_input_direction = -10
	
	
	if colliding_element != null and colliding_element.get_collision_layer_value(5) and moves:#Teleporter
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
			$TeleportAudio.play()
			just_teleported = true
		
	if colliding_element != null and moves:
		if colliding_element.get_collision_layer_value(10): #Overlapping because Iframes
			SignalBus.overlapped.emit()
		elif colliding_element.get_collision_layer_value(1) or\
			colliding_element.get_collision_layer_value(6): #Solid or Obstacle
			SignalBus.stop_moving.emit(false)
			if not hit_signal_muted:
				SignalBus.got_hit.emit()
		elif colliding_element.get_collision_layer_value(7) :#Overlap
			colliding_element.snake_overlapped.emit()
		elif colliding_element.get_collision_layer_value(2) :#Fruit
			colliding_element.collision_with.emit(colliding_element, position)
			
		if colliding_element.get_collision_layer_value(9): #TailCut
			cut.emit(colliding_element)
		if colliding_element.get_collision_layer_value(11): #Rubber
			rubber.emit()
	
	
	
	if not moves:
		next_tile = current_tile
	else:
		map.push_snake_bodyparts(current_tile, current_direction, push_overlap_bodypart)
		map.push_snake_directions(current_direction)
	
	#same check after the body was pushed, since it is the body after that, which needs to Overlap in overlap cases
	if colliding_element != null and colliding_element.get_collision_layer_value(7) :#Overlap
		push_overlap_bodypart = true
		
	SignalBus.next_tile_reached.emit()
	just_teleported = false
	get_moving_tween(moves)
	get_turning_tween(current_direction)

func _on_stop_moving(_tail_moves):
	moves = false
func _on_continue_moving(current_dir):
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


@onready var input_direction_audio: AudioStreamPlayer = $InputDirectionAudio


#region helper functions
func buffer_last_input_direction():
	var current_input_direction = buffered_input_direction
	if Input.is_action_just_pressed("move_up"):
		if buffered_input_direction == -10:
			buffered_input_direction = DIRECTION.UP
		else:
			second_buffered_input_direction = DIRECTION.UP
		input_direction_audio.play()
	if Input.is_action_just_pressed("move_right"):
		if buffered_input_direction == -10:
			buffered_input_direction = DIRECTION.RIGHT
		else:
			second_buffered_input_direction = DIRECTION.RIGHT
		input_direction_audio.play()
	if Input.is_action_just_pressed("move_down"):
		if buffered_input_direction == -10:
			buffered_input_direction = DIRECTION.DOWN
		else:
			second_buffered_input_direction = DIRECTION.DOWN
		input_direction_audio.play()
	if Input.is_action_just_pressed("move_left"):
		if buffered_input_direction == -10:
			buffered_input_direction = DIRECTION.LEFT
		else:
			second_buffered_input_direction = DIRECTION.LEFT
		input_direction_audio.play()
	if current_input_direction != buffered_input_direction or buffered_input_direction == -10:
		determine_frame_from_orientation(buffered_input_direction)

func determine_frame_from_orientation(buffered_input_direction):
	if 	buffered_input_direction == current_direction+1 or buffered_input_direction == current_direction-3:
		frame = 2 + (RunSettings.current_char * 3)
	if 	buffered_input_direction == current_direction-1 or buffered_input_direction == current_direction+3:
		frame = 1 + (RunSettings.current_char * 3)
	elif buffered_input_direction == current_direction or buffered_input_direction == -10:
		frame = 0 + (RunSettings.current_char * 3)

func check_moves():
	return moves
#endregion

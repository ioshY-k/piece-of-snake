class_name FruitElement extends MapElement

enum move_type {RANDOM,AWAY,TOWARDS}

var particle_scene = load("res://MapElements/FruitElements/fruit_collect_particles.tscn")
var is_riping_fruit = false
var collected = false
@onready var raycast_up: RayCast2D = $RaycastUp
@onready var raycast_right: RayCast2D = $RaycastRight
@onready var raycast_down: RayCast2D = $RaycastDown
@onready var raycast_left: RayCast2D = $RaycastLeft
@onready var fruit_element_sprite: AnimatedSprite2D = $FruitElementSprite

func collected_anim(snakehead_pos: Vector2, fruit_destination_pos: Vector2):
	set_collision_layer_value(2,false)
	var tweenforth = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel(true)
	tweenforth.tween_property(self, "position", position+(snakehead_pos-position).rotated(deg_to_rad(180)), 0.15)
	tweenforth.tween_property(self, "scale", Vector2(1.5,1.5), 0.15)
	await tweenforth.finished
	var tweenback = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_parallel(true)
	tweenback.tween_property(self, "position", snakehead_pos, 0.1)
	tweenback.tween_property(self, "scale", Vector2.ZERO, 0.1)
	await tweenback.finished
	var particles: CPUParticles2D = particle_scene.instantiate()
	get_parent().add_child(particles)
	particles.position = fruit_destination_pos
	await get_tree().process_frame
	particles.emitting = false
	queue_free()

func valid_direction_towards_player():
	var horizontal_distance_is_longer = abs(position.x-map.snake_head.position.x) > abs(position.y-map.snake_head.position.y)
	if horizontal_distance_is_longer:
		if position.x > map.snake_head.position.x and raycast_left.get_collider() == null:
			return TileHelper.DIRECTION.LEFT
		if position.x < map.snake_head.position.x and raycast_right.get_collider() == null:
			return TileHelper.DIRECTION.RIGHT
		if position.y > map.snake_head.position.y and raycast_up.get_collider() == null:
			return TileHelper.DIRECTION.UP
		if position.y < map.snake_head.position.y and raycast_down.get_collider() == null:
			return TileHelper.DIRECTION.DOWN
	else:
		if position.y > map.snake_head.position.y and raycast_up.get_collider() == null:
			return TileHelper.DIRECTION.UP
		if position.y < map.snake_head.position.y and raycast_down.get_collider() == null:
			return TileHelper.DIRECTION.DOWN
		if position.x > map.snake_head.position.x and raycast_left.get_collider() == null:
			return TileHelper.DIRECTION.LEFT
		if position.x < map.snake_head.position.x and raycast_right.get_collider() == null:
			return TileHelper.DIRECTION.RIGHT
	return null

func valid_direction_awayfrom_player():
	var horizontal_distance_is_longer = abs(position.x-map.snake_head.position.x) > abs(position.y-map.snake_head.position.y)
	if horizontal_distance_is_longer:
		if position.x > map.snake_head.position.x and raycast_right.get_collider() == null:
			return TileHelper.DIRECTION.RIGHT
		if position.x < map.snake_head.position.x and raycast_left.get_collider() == null:
			return TileHelper.DIRECTION.LEFT
		if position.y > map.snake_head.position.y and raycast_down.get_collider() == null:
			return TileHelper.DIRECTION.DOWN
		if position.y < map.snake_head.position.y and raycast_up.get_collider() == null:
			return TileHelper.DIRECTION.UP
	else:
		if position.y > map.snake_head.position.y and raycast_down.get_collider() == null:
			return TileHelper.DIRECTION.DOWN
		if position.y < map.snake_head.position.y and raycast_up.get_collider() == null:
			return TileHelper.DIRECTION.UP
		if position.x > map.snake_head.position.x and raycast_right.get_collider() == null:
			return TileHelper.DIRECTION.RIGHT
		if position.x < map.snake_head.position.x and raycast_left.get_collider() == null:
			return TileHelper.DIRECTION.LEFT
	return null
	

func random_valid_direction():
	var valid_directions: Array[int] = []
	if raycast_up.get_collider() == null:
		valid_directions.append(TileHelper.DIRECTION.UP)
	if raycast_right.get_collider() == null:
		valid_directions.append(TileHelper.DIRECTION.RIGHT)
	if raycast_down.get_collider() == null:
		valid_directions.append(TileHelper.DIRECTION.DOWN)
	if raycast_left.get_collider() == null:
		valid_directions.append(TileHelper.DIRECTION.LEFT)
	if valid_directions.size() > 0:
		return valid_directions[randi()%valid_directions.size()]
	else:
		return null
		
var movement_tween: Tween
func move(move_t):
	if is_instance_valid(movement_tween):
		while movement_tween.is_running():
			await movement_tween.finished
			print("waiting over!")
	
	var direction
	match move_t:
		move_type.RANDOM:
			direction = random_valid_direction()
		move_type.AWAY:
			direction = valid_direction_awayfrom_player()
		move_type.TOWARDS:
			direction = valid_direction_towards_player()
		
	movement_tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	match direction:
		TileHelper.DIRECTION.UP:
			movement_tween.tween_property(self, "position",
			TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(position),TileHelper.DIRECTION.UP)),
			map.snake_head.current_snake_speed)
		TileHelper.DIRECTION.RIGHT:
			movement_tween.tween_property(self, "position",
			TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(position),TileHelper.DIRECTION.RIGHT)),
			map.snake_head.current_snake_speed)
		TileHelper.DIRECTION.DOWN:
			movement_tween.tween_property(self, "position",
			TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(position),TileHelper.DIRECTION.DOWN)),
			map.snake_head.current_snake_speed)
		TileHelper.DIRECTION.LEFT:
			movement_tween.tween_property(self, "position",
			TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(position),TileHelper.DIRECTION.LEFT)),
			map.snake_head.current_snake_speed)
		null:
			print("no valid direction found")
			movement_tween.tween_property(self, "position",position,map.snake_head.current_snake_speed)

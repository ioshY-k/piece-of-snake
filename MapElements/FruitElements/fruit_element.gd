class_name FruitElement extends MapElement

enum move_type {UP,RIGHT,DOWN,LEFT,RANDOM,AWAY,TOWARDS}
const DIFFUSED_UP: int = -1
const DIFFUSED_RIGHT: int = -2
const DIFFUSED_DOWN: int = -3
const DIFFUSED_LEFT: int = -4

var particle_scene = load("res://MapElements/FruitElements/fruit_collect_particles.tscn")
var is_riping_fruit = false
var collected = false
var diffusable = false
var big = false
@onready var raycast_up: RayCast2D = $RaycastUp
@onready var raycast_right: RayCast2D = $RaycastRight
@onready var raycast_down: RayCast2D = $RaycastDown
@onready var raycast_left: RayCast2D = $RaycastLeft
@onready var fruit_element_sprite: AnimatedSprite2D = $FruitElementSprite

func collected_anim(snakehead_pos: Vector2, fruit_destination_pos: Vector2):
	await get_tree().process_frame
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
		elif diffusable and raycast_left.get_collider() != null and raycast_left.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_LEFT
		if position.x < map.snake_head.position.x and raycast_right.get_collider() == null:
			return TileHelper.DIRECTION.RIGHT
		elif diffusable and raycast_right.get_collider() != null and raycast_right.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_RIGHT
		if position.y > map.snake_head.position.y and raycast_up.get_collider() == null:
			return TileHelper.DIRECTION.UP
		elif diffusable and raycast_up.get_collider() != null and raycast_up.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_UP
		if position.y < map.snake_head.position.y and raycast_down.get_collider() == null:
			return TileHelper.DIRECTION.DOWN
		elif diffusable and raycast_down.get_collider() != null and raycast_down.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_DOWN
	else:
		if position.y > map.snake_head.position.y and raycast_up.get_collider() == null:
			return TileHelper.DIRECTION.UP
		elif diffusable and raycast_up.get_collider() != null and raycast_up.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_UP
		if position.y < map.snake_head.position.y and raycast_down.get_collider() == null:
			return TileHelper.DIRECTION.DOWN
		elif diffusable and raycast_down.get_collider() != null and raycast_down.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_DOWN
		if position.x > map.snake_head.position.x and raycast_left.get_collider() == null:
			return TileHelper.DIRECTION.LEFT
		elif diffusable and raycast_left.get_collider() != null and raycast_left.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_LEFT
		if position.x < map.snake_head.position.x and raycast_right.get_collider() == null:
			return TileHelper.DIRECTION.RIGHT
		elif diffusable and raycast_right.get_collider() != null and raycast_right.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_RIGHT
	return null

func valid_direction_awayfrom_player():
	var horizontal_distance_is_longer = abs(position.x-map.snake_head.position.x) > abs(position.y-map.snake_head.position.y)
	if horizontal_distance_is_longer:
		if position.x >= map.snake_head.position.x and raycast_right.get_collider() == null:
			return TileHelper.DIRECTION.RIGHT
		elif diffusable and raycast_right.get_collider() != null and raycast_right.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_RIGHT
		if position.x <= map.snake_head.position.x and raycast_left.get_collider() == null:
			return TileHelper.DIRECTION.LEFT
		elif diffusable and raycast_left.get_collider() != null and raycast_left.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_LEFT
		if position.y >= map.snake_head.position.y and raycast_down.get_collider() == null:
			return TileHelper.DIRECTION.DOWN
		elif diffusable and raycast_down.get_collider() != null and raycast_down.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_DOWN
		if position.y <= map.snake_head.position.y and raycast_up.get_collider() == null:
			return TileHelper.DIRECTION.UP
		elif diffusable and raycast_up.get_collider() != null and raycast_up.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_UP
	else:
		if position.y >= map.snake_head.position.y and raycast_down.get_collider() == null:
			return TileHelper.DIRECTION.DOWN
		elif diffusable and raycast_down.get_collider() != null and raycast_down.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_DOWN
		if position.y <= map.snake_head.position.y and raycast_up.get_collider() == null:
			return TileHelper.DIRECTION.UP
		elif diffusable and raycast_up.get_collider() != null and raycast_up.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_UP
		if position.x >= map.snake_head.position.x and raycast_right.get_collider() == null:
			return TileHelper.DIRECTION.RIGHT
		elif diffusable and raycast_right.get_collider() != null and raycast_right.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_RIGHT
		if position.x <= map.snake_head.position.x and raycast_left.get_collider() == null:
			return TileHelper.DIRECTION.LEFT
		elif diffusable and raycast_left.get_collider() != null and raycast_left.get_collider().get_parent().is_in_group("Snake"):
			return DIFFUSED_LEFT
	return null
	

func random_valid_direction():
	var valid_directions: Array[int] = []
	if raycast_up.get_collider() == null:
		valid_directions.append(TileHelper.DIRECTION.UP)
	elif diffusable and raycast_up.get_collider().get_parent().is_in_group("Snake"):
		valid_directions.append(DIFFUSED_UP)
	if raycast_right.get_collider() == null:
		valid_directions.append(TileHelper.DIRECTION.RIGHT)
	elif diffusable and raycast_right.get_collider().get_parent().is_in_group("Snake"):
		valid_directions.append(DIFFUSED_RIGHT)
	if raycast_down.get_collider() == null:
		valid_directions.append(TileHelper.DIRECTION.DOWN)
	elif diffusable and raycast_down.get_collider().get_parent().is_in_group("Snake"):
		valid_directions.append(DIFFUSED_DOWN)
	if raycast_left.get_collider() == null:
		valid_directions.append(TileHelper.DIRECTION.LEFT)
	elif diffusable and raycast_left.get_collider().get_parent().is_in_group("Snake"):
		valid_directions.append(DIFFUSED_LEFT)
		
	if valid_directions.size() > 0:
		return valid_directions[randi()%valid_directions.size()]
	else:
		return null

var blocked_by_dance: bool = false
var movement_tween: Tween
func move(move_t, triggered_by_dance):
	if get_parent().name == "PlantSnakeComponent":
		return
	if is_instance_valid(movement_tween):
		while movement_tween.is_running():
			await movement_tween.finished
	
	if collected:
		return
	if big and move_t != move_type.TOWARDS:
		return
	#blocked by dance whenever snake moves while dance upgrade is equipped. triggered by dance, when dance component called move
	if blocked_by_dance and not triggered_by_dance:
		return
	
	var direction
	match move_t:
		move_type.UP:
			if raycast_up.get_collider() == null:
				direction = TileHelper.DIRECTION.UP
			else:
				if diffusable and raycast_up.get_collider().get_parent().is_in_group("Snake"):
					direction = DIFFUSED_UP
				else:
					direction = null
		move_type.RIGHT:
			if raycast_right.get_collider() == null:
				direction = TileHelper.DIRECTION.RIGHT
			else:
				if diffusable and raycast_right.get_collider().get_parent().is_in_group("Snake"):
					direction = DIFFUSED_RIGHT
				else:
					direction = null
		move_type.DOWN:
			if raycast_down.get_collider() == null:
				direction = TileHelper.DIRECTION.DOWN
			else:
				if diffusable and raycast_down.get_collider().get_parent().is_in_group("Snake"):
					direction = DIFFUSED_DOWN
				else:
					direction = null
		move_type.LEFT:
			if raycast_left.get_collider() == null:
				direction = TileHelper.DIRECTION.LEFT
			else:
				if diffusable and raycast_left.get_collider().get_parent().is_in_group("Snake"):
					direction = DIFFUSED_LEFT
				else:
					direction = null
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
			movement_tween.tween_property(self, "position",position,map.snake_head.current_snake_speed)
		DIFFUSED_UP:
			movement_tween.kill()
			collision_with.emit(self, TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(position),TileHelper.DIRECTION.UP)))
		DIFFUSED_RIGHT:
			movement_tween.kill()
			collision_with.emit(self, TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(position),TileHelper.DIRECTION.RIGHT)))
		DIFFUSED_DOWN:
			movement_tween.kill()
			collision_with.emit(self, TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(position),TileHelper.DIRECTION.DOWN)))
		DIFFUSED_LEFT:
			movement_tween.kill()
			collision_with.emit(self, TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(position),TileHelper.DIRECTION.LEFT)))

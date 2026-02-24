extends Node

var map: Map
var head:SnakeHead
var tail:SnakeTail
var is_twohead_ability: bool = false
var tail_particles: CPUParticles2D
var head_particles: CPUParticles2D

const HEAD_SWAP_PARTICLE_EFFECT = preload("res://MapModComponents/HeadSwap/head_swap_particle_effect.tscn")
const HEAD_SWAP_BODYPART_PARTICLE_EFFECT = preload("res://MapModComponents/HeadSwap/head_swap_bodypart_particle_effect.tscn")
@onready var head_swap_sound: AudioStreamPlayer = $HeadSwapSound


func instantiate_as_twohead_ability():
	is_twohead_ability = true

func _ready() -> void:
	map = get_parent()
	head = map.snake_head
	tail = map.snake_tail
	
	tail_particles = HEAD_SWAP_PARTICLE_EFFECT.instantiate()
	tail.add_child(tail_particles)
	head_particles = HEAD_SWAP_PARTICLE_EFFECT.instantiate()
	head.add_child(head_particles)
	
	if RunSettings.current_char != GameConsts.CHAR_LIST.TWOHEAD or is_twohead_ability:
		SignalBus.fruit_collected.connect(swap_head)

func swap_head(_element, is_real_collection):
	if not is_real_collection or (is_twohead_ability and map.current_mapmod == GameConsts.MAP_MODS.HEAD_SWAP):
		return
	await SignalBus.next_tile_reached
	
	head_particles.emitting = true
	tail_particles.emitting = true
	head_swap_sound.pitch_scale = randf_range(0.85,1.15)
	head_swap_sound.play()
	map.snake_path_bodyparts.reverse()
	map.snake_path_directions.reverse()
	for index in range(map.snake_path_directions.size()):
		map.snake_path_directions[index] = TileHelper.get_opposite(map.snake_path_directions[index])
	map.snake_path_directions.pop_front()
	map.snake_path_directions.push_back(map.DIRECTION.STOP)
	for body: SnakeBody in map.snake_path_bodyparts:
		body.flip_rotation()
	
	head.position = TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(tail.position),tail.current_direction))
	var dir = TileHelper.get_opposite(tail.current_direction)
	head.position = TileHelper.tile_to_position(TileHelper.get_next_tile(TileHelper.position_to_tile(head.position),dir))
	head.current_tile = TileHelper.position_to_tile(head.position)
	head.next_tile = TileHelper.position_to_tile(head.position)
	head.current_direction = TileHelper.get_opposite(tail.current_direction)
	
	var temp_rotation = tail.rotation_degrees
	tail.rotation_degrees = (int(head.rotation_degrees) + 180)%360
	head.rotation_degrees = (int(temp_rotation) + 180)%360
	
	
	await SignalBus.next_tile_reached
	var body_particle = HEAD_SWAP_BODYPART_PARTICLE_EFFECT.instantiate()
	map.snake_path_bodyparts[-1].add_child(body_particle)
	

func self_destruct():
	queue_free()

class_name SnakeBody extends AnimatedSprite2D

const SNAKE_CORNER_APPEAR_GRADIENT = preload("res://Snake/Body/snake_corner_appear_gradient.gdshader")
const BLACK_CORNER = preload("res://Shader/black_corner.gdshader")

enum DIRECTION {UP,RIGHT,DOWN,LEFT,STOP}
enum BODY_TYPE {STRAIGHT_U, STRAIGHT_R, STRAIGHT_D, STRAIGHT_L, CORNER_UR, CORNER_DR, CORNER_DL, CORNER_UL, CORNER_RU, CORNER_RD, CORNER_LD, CORNER_LU}
var body_type: int
var is_corner: bool
var orientation: int
var is_tetris: bool = false
var is_rubber: bool = false
var body_moves: bool = true
var is_overlap_bodypart: bool = false
var is_reverted_on_half: bool = false
var is_overlapped: bool = false
const snake_body_scene = preload("res://Snake/Body/snake_body.tscn")

@onready var solid_element: SolidElement = $SolidElement
@onready var snake_shadow_component: Node2D = $SnakeShadowComponent

@onready var snake_body_deco_edge: AnimatedSprite2D = $SnakeBodyDecoEdge
@onready var snake_body_deco_corner: Node2D = $SnakeBodyCornerDeco
@onready var corner_animation_player: AnimationPlayer = $CornerAnimationPlayer

@onready var hole_animation_player: AnimationPlayer = $HoleAnimationPlayer

var map: Map
var snake_head: SnakeHead

static func new_snakebody(snake_path, next_direction) -> SnakeBody:
	var snake_body: SnakeBody = snake_body_scene.instantiate()
	snake_body.find_correct_rotation(snake_path, next_direction)
	
	return snake_body

func _ready() -> void:
	if is_tetris:
		map = get_parent().get_parent().get_parent()
		frame = 2 + (RunSettings.current_char * 9) #frames per snake
		material = null
		snake_shadow_component.queue_free()
	else:
		map = get_parent()
	snake_head = map.snake_head
	
	if is_corner:
		snake_body_deco_edge.hide()
		for deco in snake_body_deco_corner.get_children():
			deco.frame = RunSettings.current_char
			
		var corner_material = ShaderMaterial.new()
		corner_material.shader = SNAKE_CORNER_APPEAR_GRADIENT
		material = corner_material.duplicate()
		
		var corner_shadow_material = ShaderMaterial.new()
		corner_shadow_material.shader = BLACK_CORNER
		snake_shadow_component.shadow.material = corner_shadow_material.duplicate()
		play_corner_deco_anim_tweens()
	else:
		snake_body_deco_corner.hide()
		snake_body_deco_edge.frame = RunSettings.current_char
		#tetrifruit snakebodies lose their material
		if material != null:
			material = material.duplicate()
		snake_body_deco_edge.material = snake_body_deco_edge.material.duplicate()
		snake_shadow_component.shadow.material = snake_shadow_component.shadow.material.duplicate()
		play_edge_deco_anim_tweens()
	
	if map.diffusing:
		$SnakeBodyDecoEdge/EdgeDiffusionHole.show()
		$SnakeBodyCornerDeco/SnakeBodyCornerDecoBack4/CornerDiffusionHoleBack.show()
		$SnakeBodyCornerDeco/SnakeBodyCornerDecoFront4/CornerDiffusionHoleFront.show()
	
	SignalBus.stop_moving.connect(_on_stop_moving)
	SignalBus.continue_moving.connect(_on_continue_moving)
	SignalBus.next_tile_reached.connect(_on_next_tile_reached)
	solid_element.snake_overlapped.connect(_on_snake_overlaps.bind(false))
	
	
func find_correct_rotation(snake_path, next_direction: int):
	var this_direction:int
	var temp_snake_path = snake_path.duplicate()
	#happens only when head and tail swap
	while temp_snake_path[-1] == 4:
		temp_snake_path.pop_back()
	this_direction = temp_snake_path[-1]
	if this_direction == next_direction:
		is_corner = false
		frame = 1 + (RunSettings.current_char * 9) #frames per snake
		match this_direction:
			DIRECTION.UP:
				rotation_degrees = 0
				body_type = BODY_TYPE.STRAIGHT_U
			DIRECTION.RIGHT:
				rotation_degrees = 90
				body_type = BODY_TYPE.STRAIGHT_R
			DIRECTION.DOWN:
				rotation_degrees = 180
				body_type = BODY_TYPE.STRAIGHT_D
			DIRECTION.LEFT:
				rotation_degrees = 270
				body_type = BODY_TYPE.STRAIGHT_L
	else:
		is_corner = true
		frame = 0 + (RunSettings.current_char * 9) #frames per snake
		match [this_direction ,next_direction]:
			[2,1]:
				rotation_degrees = 90
				body_type = BODY_TYPE.CORNER_DR
			[3,2]:
				rotation_degrees = 180
				body_type = BODY_TYPE.CORNER_LD
			[0,3]:
				rotation_degrees = 270
				body_type = BODY_TYPE.CORNER_UL
			[1,0]:
				rotation_degrees = 0
				body_type = BODY_TYPE.CORNER_RU
			[0,1]:
				rotation_degrees = 270
				scale.y = -scale.y
				body_type = BODY_TYPE.CORNER_UR
			[1,2]:
				rotation_degrees = 180
				scale.x = -scale.x
				body_type = BODY_TYPE.CORNER_RD
			[2,3]:
				rotation_degrees = 90
				scale.y = -scale.y
				body_type = BODY_TYPE.CORNER_DL
			[3,0]:
				rotation_degrees = 180
				scale.y = -scale.y
				body_type = BODY_TYPE.CORNER_LU

func flip_rotation():
	match body_type:
		BODY_TYPE.STRAIGHT_U:
			body_type = BODY_TYPE.STRAIGHT_D
			rotation_degrees += 180
		BODY_TYPE.STRAIGHT_R:
			body_type = BODY_TYPE.STRAIGHT_L
			rotation_degrees += 180
		BODY_TYPE.STRAIGHT_D:
			body_type = BODY_TYPE.STRAIGHT_U
			rotation_degrees += 180
		BODY_TYPE.STRAIGHT_L:
			body_type = BODY_TYPE.STRAIGHT_R
			rotation_degrees += 180
		BODY_TYPE.CORNER_DR:
			scale.x = -scale.x
			rotation_degrees -= 90
			body_type = BODY_TYPE.CORNER_LU
		BODY_TYPE.CORNER_LD:
			scale.x = -scale.x
			rotation_degrees -= 90
			body_type = BODY_TYPE.CORNER_UR
		BODY_TYPE.CORNER_UL:
			scale.x = -scale.x
			rotation_degrees -= 90
			body_type = BODY_TYPE.CORNER_RD
		BODY_TYPE.CORNER_RU:
			scale.x = -scale.x
			rotation_degrees -= 90
			body_type = BODY_TYPE.CORNER_DL
		BODY_TYPE.CORNER_UR:
			scale.x = -scale.x
			rotation_degrees += 90
			body_type = BODY_TYPE.CORNER_LD
		BODY_TYPE.CORNER_LU:
			scale.x = -scale.x
			rotation_degrees += 90
			body_type = BODY_TYPE.CORNER_DR
		BODY_TYPE.CORNER_DL:
			scale.x = -scale.x
			rotation_degrees += 90
			body_type = BODY_TYPE.CORNER_RU
		BODY_TYPE.CORNER_RD:
			scale.x = -scale.x
			rotation_degrees += 90
			body_type = BODY_TYPE.CORNER_UL
		

#revert_on_backhalf decides wether it is temporarily made overlap by half_gone upgrade
func set_overlap(state, revert_on_half):
	is_overlap_bodypart = state
	is_reverted_on_half = revert_on_half

	solid_element.set_collision_layer_value(6,not state)
	solid_element.set_collision_layer_value(7,state)
	if state:
		self_modulate.a = 0.7
	else:
		self_modulate.a = 1.0

func _on_snake_overlaps(called_by_spawned_bodypart: bool):
	if not is_overlapped:
		is_overlapped = true
		if not called_by_spawned_bodypart:
			SignalBus.overlapped.emit()
	else:
		SignalBus.stop_moving.emit(false)
		SignalBus.got_hit.emit()

var overlap_this_tick = true
func _on_next_tile_reached():
	if is_overlap_bodypart and is_overlapped:
		if overlap_this_tick:
			overlap_this_tick = false
			return
		if not solid_element.has_overlapping_areas():
			is_overlapped = false
			overlap_this_tick = true
			self_modulate.a = 0.7

func play_edge_deco_anim_tweens():
	await SignalBus.next_tile_reached
	
	if body_moves:
		var moving_tween: Tween = create_tween()
		moving_tween.tween_property(snake_body_deco_edge, "position:y", - GameConsts.TILE_SIZE, snake_head.current_snake_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		snake_body_deco_edge.position = Vector2.ZERO
	
	body_moves = true
	play_edge_deco_anim_tweens()
	
func play_corner_deco_anim_tweens():
	await SignalBus.next_tile_reached
	if body_moves:
		corner_animation_player.seek(0.0, true)
		var moving_tween: Tween = create_tween()
		moving_tween.tween_method(_set_animation_progress, 0.0, corner_animation_player.current_animation_length, snake_head.current_snake_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	body_moves = true
	play_corner_deco_anim_tweens()

func _set_animation_progress(time: float):
	corner_animation_player.seek(time, true)

func turn_rubber():
	is_rubber = true
	is_reverted_on_half = false
	solid_element.set_collision_layer_value(6,false)
	solid_element.set_collision_layer_value(11,true)
	var body_position = map.snake_path_bodyparts.find(self)
	if body_position == 0 or not map.snake_path_bodyparts[body_position-1].is_rubber:
		frame = 5 + (RunSettings.current_char * 9) #frames per snake
		await SignalBus.next_tile_reached
		if map.snake_path_bodyparts[body_position].is_rubber:
			frame = 6 + (RunSettings.current_char * 9) #frames per snake
	else:
		frame = 7 + (RunSettings.current_char * 9) #frames per snake
		await SignalBus.next_tile_reached
		if map.snake_path_bodyparts[body_position].is_rubber:
			frame = 8 + (RunSettings.current_char * 9) #frames per snake

func _on_stop_moving(_tail_moves):
	body_moves = false
func _on_continue_moving(current_direction):
	body_moves = true

func disappear_shader():
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(func(value):
		if material != null:
			material.set_shader_parameter("mask_height", value), 1.0, 0.0, map.snake_head.current_snake_speed)
	tween.tween_method(func(value):
		snake_shadow_component.shadow.material.set_shader_parameter("mask_height", value), 1.0, 0.0, map.snake_head.current_snake_speed)
	if !is_corner:
		tween.tween_method(func(value):
			snake_body_deco_edge.material.set_shader_parameter("mask_height", value), 1.0, 0.0, map.snake_head.current_snake_speed*2)
	SignalBus.round_over.connect(func():
		if tween.is_valid():
			tween.pause())
	SignalBus.map_paused.connect(func():
		if tween.is_valid():
			tween.pause())
	SignalBus.round_started.connect(func():
		if tween.is_valid():
			tween.play())
	SignalBus.map_continued.connect(func():
		if tween.is_valid():
			tween.play())

func appear_shader():
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_method(func(value):
		if material != null:
			material.set_shader_parameter("mask_height", value), 0.0, -1.0, map.snake_head.current_snake_speed)
	tween.tween_method(func(value):
		snake_shadow_component.shadow.material.set_shader_parameter("mask_height", value), 0.0, -1.0, map.snake_head.current_snake_speed)
	if !is_corner:
		tween.tween_method(func(value):
			snake_body_deco_edge.material.set_shader_parameter("mask_height", value), 0.0, -1.0, map.snake_head.current_snake_speed/2.5)
	SignalBus.round_over.connect(func():
		if tween.is_valid():
			tween.pause())
	SignalBus.map_paused.connect(func():
		if tween.is_valid():
			tween.pause())
	SignalBus.round_started.connect(func():
		if tween.is_valid():
			tween.play())
	SignalBus.map_continued.connect(func():
		if tween.is_valid():
			tween.play())

func show_deco_corner_in_order():
	if snake_body_deco_corner.get_children().size() != 14:
		print_debug("Showing is not synced since there are no longer 14 deco pieces on snake body! Adjust number in timer below")
		
	var reverse_deco: Array = snake_body_deco_corner.get_children()
	reverse_deco.reverse()
	for deco in reverse_deco:
		deco.hide()
	for deco in reverse_deco:
		deco.show()
		await get_tree().create_timer(map.snake_head.current_snake_speed / 14)

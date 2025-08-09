class_name SnakeBody extends AnimatedSprite2D


enum DIRECTION {UP,RIGHT,DOWN,LEFT,STOP}
enum BODY_TYPE {STRAIGHT_U, STRAIGHT_R, STRAIGHT_D, STRAIGHT_L, CORNER_UR, CORNER_DR, CORNER_DL, CORNER_UL}
var is_corner: bool
var body_moves: bool = true
var is_overlap_bodypart: bool = false
var is_overlapped: bool = false
var is_tetris: bool = false
const snake_body_scene = preload("res://Snake/Body/snake_body.tscn")

@onready var solid_element: SolidElement = $SolidElement

@onready var snake_body_deco_edge: Sprite2D = $SnakeBodyDecoEdge
@onready var snake_body_deco_corner1: Sprite2D = $SnakeBodyDecoCorner1
@onready var snake_body_deco_corner2: Sprite2D = $SnakeBodyDecoCorner2
@onready var corner_animation_player: AnimationPlayer = $CornerAnimationPlayer


var snake_head: SnakeHead

static func new_snakebody(this_direction, next_direction) -> SnakeBody:
	var snake_body: SnakeBody = snake_body_scene.instantiate()
	snake_body.find_correct_rotation(this_direction, next_direction)
	
	return snake_body

func _ready() -> void:
	if is_tetris:
		snake_head = get_parent().get_parent().snake_head
		frame = 2
	else:
		snake_head = get_parent().snake_head
	
	if is_corner:
		snake_body_deco_edge.hide()
		play_corner_deco_anim_tweens()
		
	else:
		snake_body_deco_corner1.hide()
		snake_body_deco_corner2.hide()
		play_edge_deco_anim_tweens()
	
	SignalBus.stop_moving.connect(_on_stop_moving)
	SignalBus.continue_moving.connect(_on_continue_moving)
	SignalBus.next_tile_reached.connect(_on_next_tile_reached)
	solid_element.snake_overlapped.connect(_on_snake_overlaps.bind(false))
	
	
func find_correct_rotation(this_direction: int, next_direction: int):
	if this_direction == next_direction:
		is_corner = false
		frame = 1
		match this_direction:
			DIRECTION.UP:
				rotation_degrees = 0
				
			DIRECTION.RIGHT:
				rotation_degrees = 90
				
			DIRECTION.DOWN:
				rotation_degrees = 180
				
			DIRECTION.LEFT:
				rotation_degrees = 270
	else:
		is_corner = true
		frame = 0
		match [this_direction ,next_direction]:
			[2,1]:
				rotation_degrees = 90
			[3,2]:
				rotation_degrees = 180
			[0,3]:
				rotation_degrees = 270
			[1,0]:
				rotation_degrees = 0
			[0,1]:
				rotation_degrees = 270
				scale.y = -scale.y
			[1,2]:
				rotation_degrees = 180
				scale.x = -scale.x
			[2,3]:
				rotation_degrees = 90
				scale.y = -scale.y
			[3,0]:
				rotation_degrees = 180
				scale.y = -scale.y

func set_overlap(state):
	is_overlap_bodypart = true

	solid_element.set_collision_layer_value(6,not state)
	solid_element.set_collision_layer_value(7,state)
	self_modulate.a = 0.7

func _on_snake_overlaps(called_by_spawned_bodypart: bool):
	if not is_overlapped:
		is_overlapped = true
		if not called_by_spawned_bodypart:
			SignalBus.overlapped.emit()
	else:
		SignalBus.stop_moving.emit()
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

func _on_stop_moving():
	body_moves = false
func _on_continue_moving():
	body_moves = true

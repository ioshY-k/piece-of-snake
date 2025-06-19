class_name SnakeBody extends AnimatedSprite2D


enum DIRECTION {UP,RIGHT,DOWN,LEFT}
enum BODY_TYPE {STRAIGHT_U, STRAIGHT_R, STRAIGHT_D, STRAIGHT_L, CORNER_UR, CORNER_DR, CORNER_DL, CORNER_UL}
var is_corner: bool
var dummy_float: float
const snake_body_scene = preload("res://Snake/Body/snake_body.tscn")
@onready var snake_body_deco_edge: Sprite2D = $SubViewportContainer/SubViewport/SnakeBodyDecoEdge
@onready var snake_body_deco_corner1: Sprite2D = $SubViewportContainer/SubViewport/SnakeBodyDecoCorner1
@onready var snake_body_deco_corner2: Sprite2D = $SubViewportContainer/SubViewport/SnakeBodyDecoCorner2
@onready var corner_animation_player: AnimationPlayer = $SubViewportContainer/SubViewport/CornerAnimationPlayer


@onready var snake_head: SnakeHead = get_parent().snake_head

@onready var sub_viewport_container: SubViewportContainer = $SubViewportContainer

static func new_snakebody(this_direction, next_direction) -> SnakeBody:
	
	var snake_body: SnakeBody = snake_body_scene.instantiate()
	snake_body.find_correct_rotation(this_direction, next_direction)
			
	return snake_body

func _ready() -> void:
	print(snake_body_deco_edge.position)
	if is_corner:
		snake_body_deco_edge.hide()
		play_corner_deco_anim_tweens()
		
	else:
		snake_body_deco_corner1.hide()
		snake_body_deco_corner2.hide()
		play_edge_deco_anim_tweens()
		

	

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
			[2,1], [3,0]:
				rotation_degrees = 90
			[0,1], [3,2]:
				rotation_degrees = 180
			[1,2], [0,3]:
				rotation_degrees = 270
			[2,3], [1,0]:
				rotation_degrees = 0
			
func play_edge_deco_anim_tweens():
	await snake_head.next_tile_reached
	var moving_tween: Tween = create_tween()
	moving_tween.tween_property(snake_body_deco_edge, "position:y", 120 - GameConsts.TILE_SIZE, snake_head.snake_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	snake_body_deco_edge.position = Vector2(40,120)
	
	play_edge_deco_anim_tweens()
	
func play_corner_deco_anim_tweens():
	await snake_head.next_tile_reached
	
	var moving_tween: Tween = create_tween()
	moving_tween.tween_method(_set_animation_progress, 0.0, corner_animation_player.current_animation_length, snake_head.snake_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	dummy_float = 0.0
	play_corner_deco_anim_tweens()

func _set_animation_progress(time: float):
	corner_animation_player.seek(time, true)

#converts a tile vector to it's actual position
func tile_to_position(tile: Vector2i) -> Vector2:
	return tile * GameConsts.TILE_SIZE

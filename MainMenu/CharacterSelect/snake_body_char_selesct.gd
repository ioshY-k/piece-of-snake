class_name SnakeBodyCharSelect extends Sprite2D


enum DIRECTION {UP,RIGHT,DOWN,LEFT,STOP}
enum BODY_TYPE {STRAIGHT_U, STRAIGHT_R, STRAIGHT_D, STRAIGHT_L, CORNER_UR, CORNER_DR, CORNER_DL, CORNER_UL}
@export var is_corner: bool
@export var sprite: Texture2D
const snake_body_scene = preload("res://Snake/Body/snake_body.tscn")

var character_select
@onready var snake_body_deco_edge: Sprite2D = $SnakeBodyDecoEdge
@onready var snake_body_deco_corner1: Sprite2D = $SnakeBodyDecoCorner1
@onready var snake_body_deco_corner2: Sprite2D = $SnakeBodyDecoCorner2
@onready var corner_animation_player: AnimationPlayer = $CornerAnimationPlayer

func _ready() -> void:
	character_select = get_parent()
	
	texture = sprite
	if is_corner:
		snake_body_deco_edge.hide()
		play_corner_deco_anim_tweens()
		
	else:
		snake_body_deco_corner1.hide()
		snake_body_deco_corner2.hide()
		play_edge_deco_anim_tweens()

func play_edge_deco_anim_tweens():
	await character_select.next_tile_reached
	
	var moving_tween: Tween = create_tween()
	moving_tween.tween_property(snake_body_deco_edge, "position:y", - GameConsts.TILE_SIZE, character_select.decreasing_menu_snake_speed).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	snake_body_deco_edge.position = Vector2.ZERO

	play_edge_deco_anim_tweens()
	
func play_corner_deco_anim_tweens():
	await character_select.next_tile_reached
	
	corner_animation_player.seek(0.0, true)
	var moving_tween: Tween = create_tween()
	moving_tween.tween_method(_set_animation_progress, 0.0, corner_animation_player.current_animation_length, character_select.decreasing_menu_snake_speed).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	
	play_corner_deco_anim_tweens()

func _set_animation_progress(time: float):
	corner_animation_player.seek(time, true)

extends Node2D

var shadow_offset = Vector2(7,15)
@onready var shadow: Sprite2D = $Shadow

func _ready() -> void:
	await get_tree().process_frame
	show()
	var object_with_shadow: AnimatedSprite2D = get_parent()
	
	if object_with_shadow.name == "SnakeHead" or object_with_shadow.name == "SnakeTail":
		shadow.material.set_shader_parameter("mask_height", 1.0)
	
	shadow.texture = object_with_shadow.sprite_frames.get_frame_texture(
		object_with_shadow.animation,object_with_shadow.frame)

func _process(delta: float) -> void:
	global_position = get_parent().global_position + shadow_offset

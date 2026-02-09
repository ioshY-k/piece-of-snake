class_name FruitArea extends Node2D

var component
var held_long_enough: bool = false
@onready var fruit_area_sprite: AnimatedSprite2D = $FruitAreaSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var held_down_progression: Sprite2D = $FruitAreaSprite/HeldDownProgression

signal area_left

func _ready() -> void:
	component = get_parent()

func appear(pos: Vector2):
	position = pos
	animation_player.play("appear")
	print("appear")
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	fruit_area_sprite.frame = 1
	animation_player.play("held_down")


func _on_area_2d_area_exited(area: Area2D) -> void:
	if not held_long_enough:
		area_left.emit()
		fruit_area_sprite.frame = 0
		animation_player.pause()
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(held_down_progression, "scale", Vector2.ZERO, 0.1)
		tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "scale:y", 0, 0.2)
		tween.tween_callback(func(): queue_free())

#called by animation player
func self_destruct():
	queue_free()

#called by animation player
func set_held_long_enough():
	held_long_enough = true
	var map:Map = get_parent()
	for fruit in map.current_fruits:
		if not fruit.is_in_group("Ghost Fruit"):
			fruit.set_collision_layer_value(2,false)
			var tween = get_tree().create_tween()
			tween.tween_property(fruit, "global_position", map.snake_head.global_position, 0.1)
			tween.tween_callback(Callable(fruit, "set_collision_layer_value").bind(2,true))
			area_left.emit()
			return
	print_debug("the real fruit was not found in current_fruits")

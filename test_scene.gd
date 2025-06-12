extends Node2D

@onready var snake_body: SnakeBody = $SnakeBody
@onready var snake_body_2: SnakeBody = $SnakeBody2
@onready var snake_body_3: SnakeBody = $SnakeBody3

var tween: Tween

func _ready() -> void:
	tween = create_tween()
	tween.set_loops().tween_property(snake_body, "position", Vector2.ZERO, 1)
	tween.loop_finished.connect(on_loop_finished)
	
func on_loop_finished(number:int):
	print("nextloop" + str(number))

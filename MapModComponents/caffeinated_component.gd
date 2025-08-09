extends Node

var map: Map

func _ready() -> void:
	map = get_parent()
	map.snake_head.base_snake_speed -= 0.07
	map.snake_head.current_snake_speed -= 0.07
	map.snake_tail.base_snake_speed -= 0.07
	map.snake_tail.current_snake_speed -= 0.07

func self_destruct():
	map.snake_head.base_snake_speed += 0.07
	map.snake_head.current_snake_speed += 0.07
	map.snake_tail.base_snake_speed += 0.07
	map.snake_tail.current_snake_speed += 0.07
	queue_free()

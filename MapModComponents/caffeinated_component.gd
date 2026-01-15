extends Node

var map: Map

func _ready() -> void:
	await SignalBus.next_tile_reached
	map = get_parent()
	map.caffeinated = true
	map.snake_head.base_snake_speed /= 1.2
	map.snake_head.current_snake_speed /= 1.2
	map.snake_tail.base_snake_speed /= 1.2
	map.snake_tail.current_snake_speed /= 1.2
	if RunSettings.current_char == GameConsts.CHAR_LIST.OSTRICH:
		for obstacle in map.obstacle_elements.get_children(false):
			if obstacle.tween != null:
				obstacle.tween.set_speed_scale(1.2*1.4)
	else:
		for obstacle in map.obstacle_elements.get_children(false):
			if obstacle.tween != null:
				obstacle.tween.set_speed_scale(1.2)

func self_destruct():
	map.caffeinated = false
	map.snake_head.base_snake_speed *= 1.2
	map.snake_head.current_snake_speed *= 1.2
	map.snake_tail.base_snake_speed *= 1.2
	map.snake_tail.current_snake_speed *= 1.2
	if RunSettings.current_char == GameConsts.CHAR_LIST.OSTRICH:
		for obstacle in map.obstacle_elements.get_children(false):
			if obstacle.tween != null:
				obstacle.tween.set_speed_scale(1.4)
	else:
		for obstacle in map.obstacle_elements.get_children(false):
			if obstacle.tween != null:
				obstacle.tween.set_speed_scale(1)
	queue_free()

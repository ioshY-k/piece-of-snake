extends Node

var snake_head: SnakeHead

func _ready() -> void:
	snake_head = get_parent()
	
	snake_head.map.get_parent().fruit_punishment *= 2
	SignalBus.pre_next_tile_reached.connect(_on_next_tile_reached)

func _on_next_tile_reached():
	var pressing_forward: bool = false
	match snake_head.current_direction:
		snake_head.DIRECTION.UP:
			pressing_forward = Input.is_action_pressed("move_up")
		snake_head.DIRECTION.RIGHT:
			pressing_forward = Input.is_action_pressed("move_right")
		snake_head.DIRECTION.DOWN:
			pressing_forward = Input.is_action_pressed("move_down")
		snake_head.DIRECTION.LEFT:
			pressing_forward = Input.is_action_pressed("move_left")
		
	if snake_head.buffered_input_direction == -10 and not pressing_forward:
		print("no input")
		SignalBus.stop_moving.emit()

func self_destruct():
	snake_head.map.get_parent().fruit_punishment /= 2
	queue_free()

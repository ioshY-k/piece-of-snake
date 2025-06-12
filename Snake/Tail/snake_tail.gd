class_name Tail extends MovingSnakePart


func _on_next_tile_reached():
	current_tile = next_tile
	
	map.delete_snake_body()
	current_direction = map.pop_snake_path_directions()
	print(current_direction)

	next_tile = map.get_next_tile(next_tile, current_direction)
	
	
	get_tree().create_tween().tween_property(self, "position", map.tile_to_position(next_tile), 0.7).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	get_tree().create_tween().tween_property(self, "rotation", get_orientation(current_direction, rotation), 0.4).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)


func get_orientation(direction: int, current_rotation: float):
	match direction:
		DIRECTION.UP:
			return 0
		DIRECTION.RIGHT:
			if current_rotation < -3 * PI/4:
				rotation = PI
			return PI/2
		DIRECTION.DOWN:
			if current_rotation < (-1/4 * PI) and current_rotation < (-3/4 * PI):
				return -PI
			return PI
		DIRECTION.LEFT:
			if current_rotation > 3 * PI/4:
				rotation = -PI
			return -PI/2

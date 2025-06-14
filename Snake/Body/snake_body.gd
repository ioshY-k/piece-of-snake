class_name SnakeBody extends AnimatedSprite2D


enum DIRECTION {UP,RIGHT,DOWN,LEFT}

func find_correct_rotation(this_direction, next_direction):
	if this_direction == next_direction:
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
			
			

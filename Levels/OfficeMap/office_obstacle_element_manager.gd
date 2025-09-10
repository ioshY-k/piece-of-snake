extends Node2D

@onready var obstacles: Array = get_children()
var tick_counter: int

func _ready() -> void:
	SignalBus.next_tile_reached.connect(call_obstacle_movements)

func call_obstacle_movements():
	tick_counter += 1
	if tick_counter % 70 == 5:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 2):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
	if tick_counter % 70 == 18:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 0):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
		for obstacle in obstacles.filter(func(o): return o.signal_id == 4):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
	if tick_counter % 70 == 22:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 5):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
		for obstacle in obstacles.filter(func(o): return o.signal_id == 6):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
	if tick_counter % 70 == 34:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 1):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
		for obstacle in obstacles.filter(func(o): return o.signal_id == 3):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
	if tick_counter % 70 == 45:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 2):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
		for obstacle in obstacles.filter(func(o): return o.signal_id == 4):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
	if tick_counter % 70 == 59:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 0):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
		for obstacle in obstacles.filter(func(o): return o.signal_id == 1):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
		for obstacle in obstacles.filter(func(o): return o.signal_id == 5):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
		for obstacle in obstacles.filter(func(o): return o.signal_id == 6):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
	if tick_counter % 70 == 65:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 3):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")
		for obstacle in obstacles.filter(func(o): return o.signal_id == 4):
			obstacle.walk_path.emit()
			if obstacle is AnimatedSprite2D: obstacle.play("DoorClosePreviewAnim")

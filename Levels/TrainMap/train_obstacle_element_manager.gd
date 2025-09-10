extends Node2D

@onready var obstacles: Array = get_children()
var tick_counter: int

func _ready() -> void:
	SignalBus.next_tile_reached.connect(call_obstacle_movements)

func call_obstacle_movements():
	tick_counter += 1
	if tick_counter % 200 == 0:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 2):
			var current_position = obstacle.position
			obstacle.path_walked.connect(func(): obstacle.position = current_position)
			obstacle.walk_path.emit()
	if tick_counter % 200 == 25:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 0):
			var current_position = obstacle.position
			obstacle.path_walked.connect(func(): obstacle.position = current_position)
			obstacle.walk_path.emit()
	if tick_counter % 200 == 50:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 4):
			var current_position = obstacle.position
			obstacle.path_walked.connect(func(): obstacle.position = current_position)
			obstacle.walk_path.emit()
	if tick_counter % 200 == 75:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 6):
			var current_position = obstacle.position
			obstacle.path_walked.connect(func(): obstacle.position = current_position)
			obstacle.walk_path.emit()
	if tick_counter % 200 == 100:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 1):
			var current_position = obstacle.position
			obstacle.path_walked.connect(func(): obstacle.position = current_position)
			obstacle.walk_path.emit()
	if tick_counter % 200 == 125:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 5):
			var current_position = obstacle.position
			obstacle.path_walked.connect(func(): obstacle.position = current_position)
			obstacle.walk_path.emit()
	if tick_counter % 200 == 150:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 3):
			var current_position = obstacle.position
			obstacle.path_walked.connect(func(): obstacle.position = current_position)
			obstacle.walk_path.emit()
	if tick_counter % 200 == 175:
		for obstacle in obstacles.filter(func(o): return o.signal_id == 7):
			var current_position = obstacle.position
			obstacle.path_walked.connect(func(): obstacle.position = current_position)
			obstacle.walk_path.emit()

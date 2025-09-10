extends Node2D

@onready var obstacles: Array = get_children()
@export var duration_hightide: int
var tick_counter: int

func _ready() -> void:
	for obstacle in obstacles:
		for i in range(duration_hightide):
			obstacle.path.insert(7,4)
		if obstacle is ObstacleHitboxElement or obstacle.has_node("Particles"):
			var first = obstacle.path.pop_front()
			obstacle.path.append(first)
		if obstacle.has_node("Particles"):
			var first = obstacle.path.pop_front()
			obstacle.path.append(first)
			first = obstacle.path.pop_front()
			obstacle.path.append(first)
	SignalBus.next_tile_reached.connect(call_obstacle_movements)

func call_obstacle_movements():
	tick_counter += 1
	if tick_counter % 72 == 2:
		for obstacle in obstacles.filter(func(o): return o.is_in_group("Tide1")):
			obstacle.walk_path.emit()
	if tick_counter % 72 == 20:
		for obstacle in obstacles.filter(func(o): return o.is_in_group("Tide2")):
			obstacle.walk_path.emit()
	if tick_counter % 72 == 38:
		for obstacle in obstacles.filter(func(o): return o.is_in_group("Tide3")):
			obstacle.walk_path.emit()
	if tick_counter % 72 == 56:
		for obstacle in obstacles.filter(func(o): return o.is_in_group("Tide4")):
			obstacle.walk_path.emit()



#extends Node2D
#
#@export var duration_hightide: int
#@export var duration_lowtide: int
#
#func _ready() -> void:
	#for obstacle in get_children():
		#for i in range(duration_hightide):
			#obstacle.path.insert(4,4)
		#for i in range(duration_lowtide):
			#obstacle.path.insert(0,4)
		#
		#var waiting_time = duration_hightide+duration_lowtide+6
		#if obstacle.is_in_group("Tide1"):
			#for i in range(waiting_time*3):
				#obstacle.path.append(4)
		#if obstacle.is_in_group("Tide2"):
			#for i in range(waiting_time*1):
				#obstacle.path.insert(0,4)
			#for i in range(waiting_time*2):
				#obstacle.path.append(4)
		#if obstacle.is_in_group("Tide3"):
			#for i in range(waiting_time*2):
				#obstacle.path.insert(0,4)
			#for i in range(waiting_time*1):
				#obstacle.path.append(4)
		#if obstacle.is_in_group("Tide4"):
			#for i in range(waiting_time*3):
				#obstacle.path.insert(0,4)
		

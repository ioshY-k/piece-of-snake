extends Node2D

@export var duration_hightide: int
@export var duration_lowtide: int

func _ready() -> void:
	for obstacle in get_children():
		for i in range(duration_hightide):
			obstacle.path.insert(4,4)
		for i in range(duration_lowtide):
			obstacle.path.insert(0,4)
		
		var waiting_time = duration_hightide+duration_lowtide+6
		if obstacle.is_in_group("Tide1"):
			for i in range(waiting_time*3):
				obstacle.path.append(4)
		if obstacle.is_in_group("Tide2"):
			for i in range(waiting_time*1):
				obstacle.path.insert(0,4)
			for i in range(waiting_time*2):
				obstacle.path.append(4)
		if obstacle.is_in_group("Tide3"):
			for i in range(waiting_time*2):
				obstacle.path.insert(0,4)
			for i in range(waiting_time*1):
				obstacle.path.append(4)
		if obstacle.is_in_group("Tide4"):
			for i in range(waiting_time*3):
				obstacle.path.insert(0,4)
		
		if obstacle is ObstacleHitboxElement or obstacle.has_node("Particles"):
			var first = obstacle.path.pop_front()
			obstacle.path.append(first)
		if obstacle.has_node("Particles"):
			print("didit")
			var first = obstacle.path.pop_front()
			obstacle.path.append(first)
			first = obstacle.path.pop_front()
			obstacle.path.append(first)

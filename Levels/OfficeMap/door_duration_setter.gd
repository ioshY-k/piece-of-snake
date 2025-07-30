extends Node2D

@export var duration: int

func _ready() -> void:
	for obstacle in get_children():
		var x = duration
		while x > 0:
			obstacle.path.insert(1, 4)
			obstacle.path.insert(obstacle.path.size()-2, 4)
			x -= 1

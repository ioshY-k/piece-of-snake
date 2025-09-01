extends Node

var map:Map

func _ready() -> void:
	map = get_parent()
	SignalBus.continue_moving.connect(_fruit_mirror_snake)
	SignalBus.stop_moving.connect(_enable_other_movements)

func _fruit_mirror_snake():
	for fruit in map.find_all_fruits():
		fruit.

func _enable_other_movements():
	pass

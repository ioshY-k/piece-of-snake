class_name MayFlyBase extends Node

var one_time_insect: bool = false
var map: Map
var level: LevelManager
var mayfly_scene = load("res://UpgradeComponents/MayFly/may_fly.tscn")

signal caught

func _ready():
	print("mayfly is here")
	level = get_parent()
	map = level.current_map
	caught.connect(set_length_to_half)
	if one_time_insect:
		spawn_mayflies()
	else:
		SignalBus.round_started.connect(spawn_mayflies)

func spawn_mayflies():
	print_debug("this function should have been overloaded")

func setup_mayfly():
	print_debug("this function should have been overloaded")

func set_length_to_half():
	var tail = map.snake_tail
	if map.snake_path_bodyparts.size() < 2:
		return
	for i in range(map.snake_path_bodyparts.size()/2):
		var body = map.snake_path_bodyparts.pop_front()
		body.queue_free()
		var direction = map.snake_path_directions.pop_front()
		tail.tiles_to_grow += 1
		
	await get_tree().process_frame
	tail.teleport_destination = TileHelper.position_to_tile(map.snake_path_bodyparts[0].position)

func self_destruct():
	queue_free()

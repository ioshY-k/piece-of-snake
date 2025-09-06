extends Node

var level: LevelManager
var map:Map

func _ready() -> void:
	level = get_parent().get_parent()
	map = get_parent()
	level.ghost_invasion = true
	SignalBus.fruit_collected.connect(_prevent_growth)

func _prevent_growth(fruit, _is_real_collection):
	if fruit != null and not fruit.is_in_group("Ghost Fruit"):
		_spawn_ghost_fruits()
		if map.snake_tail.tiles_to_grow > 0:
			map.snake_tail.tiles_to_grow -= 1

func _spawn_ghost_fruits():
	map.spawn_ghost_fruit([])
	if randi()%2 == 0:
		map.spawn_ghost_fruit([])

func self_destruct():
	level.ghost_invasion = false
	queue_free()
	

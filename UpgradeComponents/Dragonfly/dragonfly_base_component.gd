class_name DragonFlyBase extends Node

var map: Map
var dragonfly_scene = load("res://UpgradeComponents/Dragonfly/dragon_fly.tscn")
var dragon_fly: DragonFly

func _ready():
	map = get_parent().current_map
	SignalBus.round_started.connect(spawn_dragonfly)
	SignalBus.round_started.connect(setup_dragonfly)

func spawn_dragonfly():
	dragon_fly = dragonfly_scene.instantiate()
	map.add_child(dragon_fly)
	dragon_fly.position = TileHelper.tile_to_position(map.free_map_tiles[0])

func setup_dragonfly():
	print_debug("this function should have been overloaded")

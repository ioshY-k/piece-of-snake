class_name DragonFlyBase extends Node

var map: Map
var level: LevelManager
var dragonfly_scene = load("res://UpgradeComponents/Dragonfly/dragon_fly.tscn")
var dragon_fly: DragonFly

signal caught

func _ready():
	level = get_parent()
	map = level.current_map
	SignalBus.round_started.connect(spawn_dragonfly)
	SignalBus.round_started.connect(setup_dragonfly)
	caught.connect(set_infinite_sprint_meter.bind(true))
	SignalBus.round_over.connect(set_infinite_sprint_meter.bind(false))

func spawn_dragonfly():
	dragon_fly = dragonfly_scene.instantiate()
	map.add_child(dragon_fly)
	dragon_fly.component = self
	dragon_fly.position = TileHelper.tile_to_position(map.free_map_tiles[0])

func setup_dragonfly():
	print_debug("this function should have been overloaded")

func set_infinite_sprint_meter(mode: bool):
	level.infinite_speed_boost = mode
	level.speed_boost_bar.infinite_particles.emitting = mode

func self_destruct():
	queue_free()

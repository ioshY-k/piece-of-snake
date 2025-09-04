extends Node

var level: LevelManager
var fast_reload: bool = false

func _ready() -> void:
	level = get_parent()
	SignalBus.stop_moving.connect(_reload_faster)
	SignalBus.pre_next_tile_reached.connect(_reload_slower)

func _reload_faster(_tail_moves):
	if not fast_reload:
		level.speed_boost_reload_speed *= 3
		fast_reload = true
		print("fastened")

func _reload_slower():
	if fast_reload:
		level.speed_boost_reload_speed /= 3
		fast_reload = false
		print("slowed")

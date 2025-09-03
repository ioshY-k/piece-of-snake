extends Node

var level:LevelManager

func _ready() -> void:
	level = get_parent().get_parent()
	level.speed_boost_drain_speed -= 100
	get_parent().scale.x += 0.2
	level.speed_boost_reload_speed += 90

func self_destruct():
	level.speed_boost_drain_speed += 100
	get_parent().scale.x -= 0.2
	level.speed_boost_reload_speed -= 90
	queue_free()
	

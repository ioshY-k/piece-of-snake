extends Node

var original_drain_speed: int
var level:LevelManager

func _ready() -> void:
	level = get_parent().get_parent()
	level.speed_boost_drain_speed -= 100
	get_parent().scale.x += 0.2
	level.speed_boost_reload_speed += 60


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("speed_boost"):
		level.speed_boost_available = true

func self_destruct():
	level.speed_boost_drain_speed += 100
	get_parent().scale.x -= 0.2
	level.speed_boost_reload_speed -= 60
	queue_free()
	

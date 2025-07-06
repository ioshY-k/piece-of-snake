extends Node

func _ready() -> void:
	get_parent().get_parent().speed_boost_drain_speed -= 165
	get_parent().scale.x += 0.35
	get_parent().get_parent().speed_boost_reload_speed += 200

func self_destruct():
	get_parent().get_parent().speed_boost_drain_speed += 165
	get_parent().scale.x -= 0.35
	get_parent().get_parent().speed_boost_reload_speed -= 200
	queue_free()
	

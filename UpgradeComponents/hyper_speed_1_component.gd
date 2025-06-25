extends Node

func _ready() -> void:
	var drain_speed = get_parent().get_parent().speed_boost_drain_speed
	get_parent().get_parent().speed_boost_drain_speed -= 165
	get_parent().scale.x += 0.35

func self_destruct():
	var drain_speed = get_parent().get_parent().speed_boost_drain_speed
	get_parent().get_parent().speed_boost_drain_speed += 165
	get_parent().scale.x -= 0.35
	

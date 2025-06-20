extends Node

func _ready() -> void:
	var drain_speed = get_parent().get_parent().speed_boost_drain_speed
	get_parent().get_parent().speed_boost_drain_speed -= drain_speed/2
	get_parent().scale.x += get_parent().scale.x / 2

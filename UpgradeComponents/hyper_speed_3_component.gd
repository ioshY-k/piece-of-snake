extends Node
var original_drain_speed: int

func _ready() -> void:
	original_drain_speed = get_parent().get_parent().speed_boost_drain_speed
	get_parent().get_parent().speed_boost_drain_speed = 0
	get_parent().scale.x += 0.35
	get_parent().change_animation("infinite_speed_anim")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("speed_boost"):
		get_parent().get_parent().speed_boost_available = true

func self_destruct():
	get_parent().get_parent().speed_boost_drain_speed += original_drain_speed
	get_parent().scale.x -= 0.35
	queue_free()
	

extends Node

var swiss_knive = false
var snake_head:SnakeHead

func _ready() -> void:
	snake_head = get_parent()
	SignalBus.stop_moving.connect(_decide_unhittable)
	SignalBus.swiss_knive_synergy.connect(_set_swiss_knive)

func _set_swiss_knive(state:bool):
	swiss_knive = state
	
func _decide_unhittable(_tail_moves):
	if snake_head.current_snake_speed == GameConsts.SPEED_BOOST_SPEED:
		if swiss_knive:
			snake_head.hit_signal_muted = true
			await get_tree().process_frame
			snake_head.hit_signal_muted = false
		elif snake_head.colliding_element != null and not snake_head.colliding_element.get_groups().has("Snake"):
			snake_head.hit_signal_muted = true
			await get_tree().process_frame
			snake_head.hit_signal_muted = false
		
	
func self_destruct():
	queue_free()

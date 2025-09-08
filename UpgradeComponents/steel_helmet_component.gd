extends Node

var swiss_knive = false
var snake_head:SnakeHead
const EFFECT_TRIGGER_TEXT = preload("res://UI/effect_trigger_text.tscn")

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
			var shield2_effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
			shield2_effect_trigger_text.initialize(shield2_effect_trigger_text.EFFECTS.SHIELDED)
			snake_head.get_parent().add_child(shield2_effect_trigger_text)
			await get_tree().process_frame
			snake_head.hit_signal_muted = false
		elif snake_head.colliding_element != null and not snake_head.colliding_element.get_groups().has("Snake"):
			snake_head.hit_signal_muted = true
			var shield1_effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
			shield1_effect_trigger_text.initialize(shield1_effect_trigger_text.EFFECTS.SHIELDED)
			snake_head.get_parent().add_child(shield1_effect_trigger_text)
			await get_tree().process_frame
			snake_head.hit_signal_muted = false
		
	
func self_destruct():
	queue_free()

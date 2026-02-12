extends Node

const EFFECT_TRIGGER_TEXT = preload("res://UI/effect_trigger_text.tscn")

func _ready() -> void:
	SignalBus.insect_caught.connect(_add_a_point)

func _add_a_point():
	SignalBus.fruit_collected.emit(null, false)
	var effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
	effect_trigger_text.initialize(effect_trigger_text.EFFECTS.BONUS_FRUIT, null)
	get_parent().current_map.add_child(effect_trigger_text)
			
func self_destruct():
	queue_free()

extends Node

const EFFECT_TRIGGER_TEXT = preload("res://UI/effect_trigger_text.tscn")

func _ready() -> void:
	SignalBus.fruit_collected.connect(_add_a_point)

func _add_a_point(fruit: FruitElement, is_real_collection):
	if not fruit == null and fruit.is_in_group("Ghost Fruit") and is_real_collection:
		if randi()%100 <= 33:
			SignalBus.fruit_collected.emit(null, false)
			var effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
			effect_trigger_text.initialize(effect_trigger_text.EFFECTS.BONUS_FRUIT)
			get_parent().current_map.add_child(effect_trigger_text)
			

func self_destruct():
	queue_free()

extends Node

const EFFECT_TRIGGER_TEXT = preload("res://UI/effect_trigger_text.tscn")

func _ready():
	SignalBus.fruit_collected.connect(_catch_bonus)

func _catch_bonus(fruit:FruitElement, is_real_collection):
	if is_real_collection and fruit.moves and randi()%100 <= 33:
		var effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
		effect_trigger_text.initialize(effect_trigger_text.EFFECTS.BONUS_FRUIT, null)
		get_parent().current_map.add_child(effect_trigger_text)
		SignalBus.fruit_collected.emit(fruit, false)

func self_destruct():
	queue_free()

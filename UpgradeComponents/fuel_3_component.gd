extends FuelBaseComponent

func apply_fruit_boni():
	SignalBus.fruit_collected.emit(null, false)
	var effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
	effect_trigger_text.initialize(effect_trigger_text.EFFECTS.BONUS_FRUIT)
	get_parent().get_parent().current_map.add_child(effect_trigger_text)
	if level.current_map.snake_tail.tiles_to_grow > 1:
		level.current_map.snake_tail.tiles_to_grow -= 2
		var growth_effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
		growth_effect_trigger_text.initialize(growth_effect_trigger_text.EFFECTS.NO_GROWTH)
		get_parent().get_parent().current_map.add_child(growth_effect_trigger_text)

extends FuelBaseComponent


func apply_fruit_boni():
	if randi()%100 < 75:
		SignalBus.fruit_collected.emit(null, false)
		var effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
		effect_trigger_text.initialize(effect_trigger_text.EFFECTS.BONUS_FRUIT, null)
		get_parent().get_parent().current_map.add_child(effect_trigger_text)

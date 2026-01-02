extends CPUParticles2D
var ripe_level: int = 0
var riped: bool = false
var very_riped: bool = false
const EFFECT_TRIGGER_TEXT = preload("res://UI/effect_trigger_text.tscn")


func _ready() -> void:
	get_parent().is_riping_fruit = true
	SignalBus.fruit_collected.connect(_on_this_fruit_collected)
	SignalBus.fruit_collected.connect(_on_other_fruit_collected)

func _on_this_fruit_collected(collected_fruit: FruitElement, _is_real_collection: bool):
	if riped and collected_fruit == get_parent():
		SignalBus.fruit_collected.emit(null, false)
		var effect1_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
		effect1_trigger_text.initialize(effect1_trigger_text.EFFECTS.BONUS_FRUIT, null)
		get_parent().get_parent().add_child(effect1_trigger_text)
	if very_riped and collected_fruit == get_parent():
		SignalBus.fruit_collected.emit(null, false)
		var effect2_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
		effect2_trigger_text.initialize(effect2_trigger_text.EFFECTS.BONUS_FRUIT, null)
		get_parent().get_parent().add_child(effect2_trigger_text)
		
func _on_other_fruit_collected(collected_fruit: FruitElement, _is_real_collection: bool):
	if collected_fruit == get_parent() or collected_fruit == null or collected_fruit.is_in_group("Ghost Fruit"):
		return
	ripe_level += 1
	if ripe_level == 3:
		riped = true
		emitting = true
	if ripe_level == 6:
		very_riped = true
		create_tween().tween_property(self, "scale_amount_max", 2.5, 0.4)

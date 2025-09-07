class_name EffectTriggerText extends Node2D

enum EFFECTS {BONUS_FRUIT, NO_GROWTH, SHIELDED}
var _effect: int
@onready var effect_trigger_text: RichTextLabel = $Container/EffectTriggerText
@onready var map: Map = get_parent()


func _ready():
	while map.effect_trigger_occupied:
		await map.effect_trigger_freed
		
	map.effect_trigger_occupied = true
	position = map.snake_head.position
	match _effect:
		EFFECTS.BONUS_FRUIT:
			effect_trigger_text.text = "BONUS [img=30]res://Shop/UI/EffectTriggerFruitSymbol.svg[/img]"
		EFFECTS.NO_GROWTH:
			effect_trigger_text.text = "NO GROWTH [img=30]res://Shop/UI/EffectTriggerNoGrowthSymbol.svg[/img]"
		EFFECTS.SHIELDED:
			effect_trigger_text.text = "SHIELDED [img=30]res://Shop/UI/EffectTriggerShieldedSymbol.svg[/img]"
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(self, "position:y", position.y-80, 2)
	tween.tween_property(self, "modulate:a", 0, 2)
	
	await get_tree().create_timer(0.15).timeout
	map.effect_trigger_occupied = false
	map.effect_trigger_freed.emit()
	await tween.finished
	queue_free()

func initialize(effect:int):
	_effect = effect

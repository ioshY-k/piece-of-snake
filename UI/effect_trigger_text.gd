class_name EffectTriggerText extends Node2D

enum EFFECTS {BONUS_FRUIT, NO_GROWTH, SHIELDED, DENSE}
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
			effect_trigger_text.text = "TASTY [img=30]res://Shop/UI/KeywordTastySymbol.svg[/img]"
			effect_trigger_text.add_theme_color_override("default_color", Color(0.372, 0.93, 0.818))
		EFFECTS.NO_GROWTH:
			effect_trigger_text.text = "HOLLOW [img=30]res://Shop/UI/KeywordHollowSymbol.svg[/img]"
			effect_trigger_text.add_theme_color_override("default_color", Color(0.921, 0.448, 0.848))
		EFFECTS.SHIELDED:
			effect_trigger_text.text = "SHIELDED [img=30]res://Shop/UI/EffectTriggerShieldedSymbol.svg[/img]"
			effect_trigger_text.add_theme_color_override("default_color", Color(0.88, 0.716, 0.598))
		EFFECTS.DENSE:
			effect_trigger_text.text = "DENSE [img=30]res://Shop/UI/KeywordDenseSymbol.svg[/img]"
			effect_trigger_text.add_theme_color_override("default_color", Color(0.67, 0.188, 0.461))
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

class_name EffectTriggerText extends Node2D

enum EFFECTS {BONUS_FRUIT, NO_GROWTH}
var _effect: int
var _snake_head: SnakeHead
@onready var effect_trigger_text: RichTextLabel = $Container/EffectTriggerText


func _ready():
	position = _snake_head.position
	match _effect:
		EFFECTS.BONUS_FRUIT:
			effect_trigger_text.text = "BONUS [img=30]res://Shop/UI/EffectTriggerFruitSymbol.svg[/img]"
		EFFECTS.NO_GROWTH:
			effect_trigger_text.text = "NO GROWTH [img=30]res://Shop/UI/EffectTriggerNoGrowthSymbol.svg[/img]"
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_parallel()
	tween.tween_property(self, "position:y", position.y-80, 2.8)
	tween.tween_property(self, "modulate:a", 0, 2.8)
	print(position)
	await tween.finished
	queue_free()

func initialize(effect:int, snake_head: SnakeHead):
	_effect = effect
	_snake_head = snake_head

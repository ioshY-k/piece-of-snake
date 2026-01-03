class_name EffectTriggerText extends Node2D

enum EFFECTS {BONUS_FRUIT, NO_GROWTH, SHIELDED, DENSE, DIFFUSION}
var _effect: int
var effect_position = null
@onready var effect_trigger_text: RichTextLabel = $Container/EffectTriggerText
@onready var map: Map = get_parent()
@onready var back_ground: Sprite2D = $Container/BackGround
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var trigger_text_audio: AudioStreamPlayer = $TriggerTextAudio


func _ready():
	while map.effect_trigger_occupied:
		await map.effect_trigger_freed
		
	if effect_position == null:
		effect_position = map.snake_head.position
	position = effect_position
	map.effect_trigger_occupied = true
	trigger_text_audio.play()
	match _effect:
		EFFECTS.BONUS_FRUIT:
			effect_trigger_text.text = "TASTY [img=30]res://Shop/UI/KeywordTastySymbol.svg[/img]"
			effect_trigger_text.add_theme_color_override("default_color", Color(0.372, 0.93, 0.818))
			back_ground.self_modulate = Color(0.531, 0.972, 0.874)
		EFFECTS.NO_GROWTH:
			position = map.snake_head.position
			effect_trigger_text.text = "HOLLOW [img=30]res://Shop/UI/KeywordHollowSymbol.svg[/img]"
			effect_trigger_text.add_theme_color_override("default_color", Color(0.921, 0.448, 0.848))
			back_ground.self_modulate = Color(0.746, 0.755, 0.919)
		EFFECTS.SHIELDED:
			effect_trigger_text.text = "SHIELDED [img=30]res://Shop/UI/EffectTriggerShieldedSymbol.svg[/img]"
			effect_trigger_text.add_theme_color_override("default_color", Color(0.88, 0.716, 0.598))
			back_ground.self_modulate = Color(0.938, 0.842, 0.775)
		EFFECTS.DENSE:
			effect_trigger_text.text = "DENSE [img=30]res://Shop/UI/KeywordDenseSymbol.svg[/img]"
			effect_trigger_text.add_theme_color_override("default_color", Color(0.67, 0.188, 0.461))
			back_ground.self_modulate = Color(0.95, 0.672, 0.896)
		EFFECTS.DIFFUSION:
			effect_trigger_text.text = "DIFFUSION [img=30]res://Shop/UI/KeywordDiffusionSymbol.svg[/img]"
			effect_trigger_text.add_theme_color_override("default_color", Color(0.392, 0.929, 0.404))
			back_ground.self_modulate = Color(0.655, 0.988, 0.647)
	
	rotation_degrees -= 15
	modulate.a = 0
	scale *= 1.15
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN).set_parallel()
	tween.tween_property(self, "rotation_degrees", rotation_degrees+15, 0.3)
	tween.tween_property(self, "modulate:a", 1, 0.3)
	tween.tween_property(self, "scale", Vector2(1,1), 0.3)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_parallel(false)
	tween.tween_property(self, "scale", Vector2(1,1), 0.5)
	tween.tween_property(self, "modulate:a", 0, 1)
	
	await get_tree().create_timer(0.15).timeout
	
	cpu_particles_2d.emitting = true
	map.effect_trigger_occupied = false
	map.effect_trigger_freed.emit()
	await tween.finished
	queue_free()

func initialize(effect:int, position_override):
	_effect = effect
	effect_position = position_override

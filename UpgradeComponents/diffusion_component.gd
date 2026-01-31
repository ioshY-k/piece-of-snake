extends Node

var map:Map
var swiss_knive
const EFFECT_TRIGGER_TEXT = preload("res://UI/effect_trigger_text.tscn")

func _ready():
	map = get_parent().current_map
	map.diffusing = true
	SignalBus.fruit_spawned.connect(_make_diffusable)
	SignalBus.ghost_fruit_spawned.connect(_make_diffusable)
	SignalBus.swiss_knive_synergy.connect(_set_swiss_knive)
	SignalBus.diffusion_happened.connect(_diffuse_animation)

func _set_swiss_knive(state:bool):
	swiss_knive = state
	if swiss_knive and not SignalBus.diffusion_happened.is_connected(_move_all_fruits):
		SignalBus.diffusion_happened.connect(_move_all_fruits)
	else:
		if SignalBus.diffusion_happened.is_connected(_move_all_fruits):
			SignalBus.diffusion_happened.disconnect(_move_all_fruits)

func _move_all_fruits(_diffusing_bodypart):
	for fruit in map.current_fruits:
		fruit.move(fruit.move_type.TOWARDS, false)

func _diffuse_animation(diffusing_body: SnakeBody):
	for body in map.snake_path_bodyparts:
		if body != null:
			body.hole_animation_player.play("suck_anim")
	var effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
	effect_trigger_text.initialize(effect_trigger_text.EFFECTS.DIFFUSION, diffusing_body.position)
	map.add_child(effect_trigger_text)
	

func _make_diffusable(fruit: FruitElement):
	fruit.diffusable = true

func self_destruct():
	for fruit:FruitElement in map.find_all_fruits():
		fruit.diffusable = false
	map.diffusing = false
	queue_free()

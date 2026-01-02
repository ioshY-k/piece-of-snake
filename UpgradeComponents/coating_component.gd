extends Node

var swiss_knive = false
var level:LevelManager
var initial_fruit_punishment
var coatings_left: int = 0
var max_times_coated: int = 1
var coat_scene = load("res://UpgradeComponents/coating.tscn")
var coat: Sprite2D
const EFFECT_TRIGGER_TEXT = preload("res://UI/effect_trigger_text.tscn")

func _ready():
	level = get_parent()
	coat = coat_scene.instantiate()
	level.current_map.snake_head.add_child(coat)
	SignalBus.round_started.connect(_apply_coat)
	SignalBus.got_hit_and_punished.connect(_coating_used)
	SignalBus.round_over.connect(_reset_fruit_punishment)
	SignalBus.act_over.connect(self_destruct)
	SignalBus.swiss_knive_synergy.connect(_set_swiss_knive)

func _set_swiss_knive(state:bool):
	swiss_knive = state
	if swiss_knive:
		coatings_left = 2
		max_times_coated = 2
	else:
		coatings_left = 1
		max_times_coated = 1
	
func _apply_coat():
	initial_fruit_punishment = level.fruit_punishment
	level.fruit_punishment = 0
	coatings_left = max_times_coated
	coat.show()

func _reset_fruit_punishment():
	level.fruit_punishment = initial_fruit_punishment

func _coating_used():
	if coatings_left > 0:
		coatings_left -= 1
		var effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
		effect_trigger_text.initialize(effect_trigger_text.EFFECTS.SHIELDED, null)
		get_parent().current_map.add_child(effect_trigger_text)
		if coatings_left == 0:
			level.fruit_punishment = initial_fruit_punishment
			coat.hide()
			

func self_destruct():
	coat.queue_free()
	queue_free()

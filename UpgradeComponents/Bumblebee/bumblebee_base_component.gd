class_name BumblebeeBase extends Node

var map: Map
var level: LevelManager
var bumblebee_scene = load("res://UpgradeComponents/Bumblebee/bumblebee.tscn")
const EFFECT_TRIGGER_TEXT = preload("res://UI/effect_trigger_text.tscn")
var bumblebee: Bumblebee
var bumblemode: bool = false
@onready var bumblemode_timer: Timer = $BumblemodeTimer


signal caught

func _ready():
	print("bumblebee is here")
	level = get_parent()
	map = level.current_map
	SignalBus.round_started.connect(spawn_bumblebee)
	SignalBus.fruit_collected.connect(_tasty_while_bumblemode)
	caught.connect(set_fruits_tasty.bind(true))
	bumblemode_timer.timeout.connect(set_fruits_tasty.bind(false))
	SignalBus.round_over.connect(set_fruits_tasty.bind(false))

func spawn_bumblebee():
	map = level.current_map
	bumblebee = bumblebee_scene.instantiate()
	map.add_child(bumblebee)
	bumblebee.component = self
	
	
func set_fruits_tasty(mode: bool):
	bumblemode = mode
	if mode:
		bumblemode_timer.start()

func _tasty_while_bumblemode(_fruit, is_real_collection):
	if bumblemode and is_real_collection:
		SignalBus.fruit_collected.emit(null, false)
		var effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
		effect_trigger_text.initialize(effect_trigger_text.EFFECTS.BONUS_FRUIT, null)
		get_parent().current_map.add_child(effect_trigger_text)
	
func self_destruct():
	queue_free()

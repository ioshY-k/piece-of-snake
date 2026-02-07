class_name BumblebeeBase extends Node

var map: Map
var level: LevelManager
var bumblebee_scene = load("res://UpgradeComponents/Bumblebee/bumblebee.tscn")
const EFFECT_TRIGGER_TEXT = preload("res://UI/effect_trigger_text.tscn")
var bumblebee: Bumblebee
var bumblemode: bool = false
@onready var bumblemode_timer: Timer = $BumblemodeTimer
const BUMBLEMODE_FRUIT_PARTICLE = preload("res://UpgradeComponents/Bumblebee/bumblemode_fruit_particle.tscn")

signal caught

func _ready():
	print("bumblebee is here")
	level = get_parent()
	map = level.current_map
	SignalBus.round_started.connect(spawn_bumblebee)
	SignalBus.fruit_collected.connect(_tasty_while_bumblemode)
	SignalBus.fruit_spawned.connect(_particles_while_bumblemode)
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
		for fruit in map.current_fruits:
			if fruit.has_node("BumbleModeFruitParticle"):
				fruit.get_node("BumbleModeFruitParticle").emitting = true
			else:
				var particles = BUMBLEMODE_FRUIT_PARTICLE.instantiate()
				fruit.add_child(particles)
	else:
		for fruit in map.current_fruits:
			if fruit.has_node("BumbleModeFruitParticle"):
				fruit.get_node("BumbleModeFruitParticle").emitting = false

func _tasty_while_bumblemode(_fruit, is_real_collection):
	if bumblemode and is_real_collection:
		SignalBus.fruit_collected.emit(null, false)
		var effect_trigger_text: EffectTriggerText = EFFECT_TRIGGER_TEXT.instantiate()
		effect_trigger_text.initialize(effect_trigger_text.EFFECTS.BONUS_FRUIT, null)
		get_parent().current_map.add_child(effect_trigger_text)

func _particles_while_bumblemode(fruit: FruitElement):
	if bumblemode:
		var particles = BUMBLEMODE_FRUIT_PARTICLE.instantiate()
		fruit.add_child(particles)
	
func self_destruct():
	queue_free()

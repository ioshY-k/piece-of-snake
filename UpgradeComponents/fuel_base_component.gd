class_name FuelBaseComponent extends Node

var speed_boost_bar: SpeedBoostBar
var level:LevelManager
const EFFECT_TRIGGER_TEXT = preload("res://UI/effect_trigger_text.tscn")

func _ready() -> void:
	speed_boost_bar = get_parent()
	level = speed_boost_bar.get_parent()
	SignalBus.fruit_collected.connect(_apply_boni)
	
func _apply_boni(_element, is_real_collection):
	if is_real_collection and\
	level.current_map.snake_head.current_snake_speed == GameConsts.SPEED_BOOST_SPEED and\
	speed_boost_bar.value <= speed_boost_bar.max_value/2:
		speed_boost_bar.value = speed_boost_bar.max_value
		apply_fruit_boni()

func apply_fruit_boni():
	print_debug("no FuelComponent found that implements apply_fruit_boni")

func self_destruct():
	queue_free()

class_name FuelBaseComponent extends Node

var speed_boost_bar: SpeedBoostBar
var level:LevelManager
var fill_amount = 0.0

func _ready() -> void:
	speed_boost_bar = get_parent()
	level = speed_boost_bar.get_parent()
	SignalBus.fruit_collected.connect(_fill_bar)
	
func _fill_bar(_element, _is_real):
	if level.current_map.snake_head.current_snake_speed == GameConsts.SPEED_BOOST_SPEED:
		speed_boost_bar.value += fill_amount

func self_destruct():
	queue_free()

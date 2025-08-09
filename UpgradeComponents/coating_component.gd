extends Node

var level:LevelManager
var initial_fruit_punishment
var coated: bool = true
var coat_scene = load("res://UpgradeComponents/coating.tscn")
var coat: Sprite2D

func _ready():
	level = get_parent()
	coat = coat_scene.instantiate()
	level.current_map.snake_head.add_child(coat)
	SignalBus.round_started.connect(_apply_coat)
	SignalBus.got_hit.connect(_coating_used)
	SignalBus.round_over.connect(_reset_fruit_punishment)

func _apply_coat():
	initial_fruit_punishment = level.fruit_punishment
	level.fruit_punishment = 0
	coated = true
	coat.show()

func _reset_fruit_punishment():
	level.fruit_punishment = initial_fruit_punishment

func _coating_used():
	if coated:
		level.fruit_punishment = initial_fruit_punishment
		coated = false
		coat.hide()

func self_destruct():
	queue_free()

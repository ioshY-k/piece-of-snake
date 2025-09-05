extends Node

var map:Map

func _ready():
	map = get_parent().current_map
	SignalBus.fruit_spawned.connect(_make_diffusable)
	SignalBus.ghost_fruit_spawned.connect(_make_diffusable)

func _make_diffusable(fruit: FruitElement):
	fruit.diffusable = true

func self_destruct():
	for fruit:FruitElement in map.find_all_fruits():
		fruit.diffusable = false
	queue_free()

extends Node

var map:Map

func _ready():
	map = get_parent().current_map
	SignalBus.fruit_spawned.connect(_make_diffusable)
	SignalBus.ghost_fruit_spawned.connect(_make_diffusable)

func _make_diffusable(fruit: FruitElement):
	fruit.diffusable = true
	fruit.area_entered.connect(_check_snake_entered)

func _check_snake_entered(area: Area2D):
	print(area.get_parent().name, " -------------------")

func self_destruct():
	for fruit:FruitElement in map.find_all_fruits():
		fruit.diffusable = false
	queue_free()

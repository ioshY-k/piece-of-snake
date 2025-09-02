extends Node

var map:Map
var counter := 0

func _ready():
	SignalBus.fruit_collected.connect(_on_fruit_collected)
	map = get_parent()

func _on_fruit_collected(fruit: FruitElement, real_collection: bool):
	if real_collection and not fruit.is_in_group("Ghost Fruit"):
		counter += 1
		if counter % 3 == 0:
			map.spawn_ghost_fruit([])

func self_destruct():
	queue_free()

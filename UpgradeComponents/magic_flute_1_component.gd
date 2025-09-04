extends Node

func _ready() -> void:
	SignalBus.active_item_used.connect(_attract_fruits)
	SignalBus.teleported.connect(_attract_fruits)

func _attract_fruits(_teleporter: Teleporter = null):
	for fruit:FruitElement in get_tree().get_nodes_in_group("Fruit"):
		fruit.move(fruit.move_type.TOWARDS, false)
		fruit.move(fruit.move_type.TOWARDS, false)

func self_destruct():
	queue_free()

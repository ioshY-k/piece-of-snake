extends Node

func _ready() -> void:
	SignalBus.active_item_used.connect(_attract_fruits)
	SignalBus.teleported.connect(_attract_fruits)

func _attract_fruits(_teleporter: Teleporter = null):
	print("emitted")
	for fruit:FruitElement in get_tree().get_nodes_in_group("Fruit"):
		fruit.move(fruit.move_type.TOWARDS)
		fruit.move(fruit.move_type.TOWARDS)

func self_destruct():
	queue_free()

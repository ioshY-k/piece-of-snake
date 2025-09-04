extends Node

func _ready():
	SignalBus.fruit_collected.connect(_catch_bonus)

func _catch_bonus(fruit:FruitElement, is_real_collection):
	if is_real_collection and fruit.moves and randi()%2 == 0:
		SignalBus.fruit_collected.emit(fruit, false)

func self_destruct():
	queue_free()

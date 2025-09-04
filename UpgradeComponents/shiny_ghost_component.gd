extends Node

func _ready() -> void:
	SignalBus.fruit_collected.connect(_add_a_point)

func _add_a_point(fruit: FruitElement, is_real_collection):
	if not fruit == null and fruit.is_in_group("Ghost Fruit") and is_real_collection:
		if randi()%2 == 0:
			SignalBus.fruit_collected.emit(null, false)

func self_destruct():
	queue_free()

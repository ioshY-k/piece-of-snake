extends Node

func _ready() -> void:
	SignalBus.stop_moving.connect(_push_fruit_away)

func _push_fruit_away(_tail_moves):
	for fruit:FruitElement in get_tree().get_nodes_in_group("Fruit"):
		fruit.move(fruit.move_type.AWAY, false)

func self_destruct():
	queue_free()

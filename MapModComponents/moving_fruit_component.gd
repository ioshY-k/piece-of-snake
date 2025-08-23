extends Node

var map:Map
var currently_moving: bool = false

func _ready() -> void:
	map = get_parent()
	SignalBus.next_tile_reached.connect(_move_fruits_by_chance)

func _move_fruits_by_chance():
	if randi()%100 < 15 and not currently_moving:
		currently_moving = true
		for fruit:FruitElement in get_tree().get_nodes_in_group("Fruit"):
			fruit.move(fruit.move_type.RANDOM)
			fruit.move(fruit.move_type.RANDOM)
			fruit.move(fruit.move_type.RANDOM)
		await get_tree().create_timer(3).timeout
		currently_moving = false

func self_destruct():
	queue_free()
		

extends Node

var map: Map

func _ready() -> void:
	map = get_parent()
	SignalBus.active_item_used.connect(_on_active_item_used)

func _on_active_item_used():
	print("grow")
	map.snake_tail.tiles_to_grow += 1

func self_destruct():
	queue_free()

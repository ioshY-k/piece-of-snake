extends Node

var map: Map

func _ready() -> void:
	map = get_parent()
	SignalBus.overlapped.connect(_on_overlap)

func _on_overlap():
	var position = TileHelper.tile_to_position(map.snake_head.next_tile)
	var obstacle_element = load("res://MapElements/ObstacleElement/obstacle_element.tscn").instantiate()
	var obstacle_hitbox_element = load("res://MapElements/ObstacleElement/obstacle_hitbox_element.tscn").instantiate()
	map.add_child(obstacle_element)
	map.add_child(obstacle_hitbox_element)
	obstacle_element.position = position
	obstacle_hitbox_element.position = position
	map.update_free_map_tiles(map.snake_head.next_tile, false)

func self_destruct():
	queue_free()

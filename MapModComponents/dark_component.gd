extends Node

var map:Map
var darkness_parts = []
var banisher = null
const DARKNESS = preload("res://MapModComponents/Dark/darkness.tscn")
const DARKNESS_BANISHER = preload("res://MapModComponents/Dark/darkness_banisher.tscn")

func _ready() -> void:
	map = get_parent()
	
	for tile in map.free_map_tiles:
		var darkness = DARKNESS.instantiate()
		map.add_child(darkness)
		darkness.position = TileHelper.tile_to_position(tile)
		darkness_parts.append(darkness)
	
	banisher = DARKNESS_BANISHER.instantiate()
	map.snake_head.add_child(banisher)

func self_destruct():
	for darkness in darkness_parts:
		if is_instance_valid(darkness):
			darkness.queue_free()
	if is_instance_valid(banisher):
		banisher.queue_free()
	queue_free()

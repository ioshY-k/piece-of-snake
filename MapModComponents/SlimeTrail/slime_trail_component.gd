extends Node

var map:Map
var tail: SnakeTail
const SLIME_TRAIL = preload("res://MapModComponents/SlimeTrail/slime_trail.tscn")

func _ready() -> void:
	map = get_parent()
	tail = map.snake_tail
	SignalBus.next_tile_reached.connect(spawn_slime_trail)
	
func spawn_slime_trail():
	var slime_trail = SLIME_TRAIL.instantiate()
	map.add_child(slime_trail)
	slime_trail.position = tail.position
	slime_trail.rotation = tail.rotation


func self_destruct():
	for node in map.get_children():
		if node.is_in_group("Slime Trail"):
			node.queue_free()
	queue_free()

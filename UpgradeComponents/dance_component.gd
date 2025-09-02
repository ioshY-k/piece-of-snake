extends Node

var map:Map
var just_stopped: bool = false

func _ready() -> void:
	map = get_parent()
	SignalBus.continue_moving.connect(_fruit_mirror_snake)
	SignalBus.stop_moving.connect(_enable_other_movements)

func _fruit_mirror_snake(current_dir):
	if just_stopped:
		return
	var opposite_dir: int = (current_dir+2) % 4
	for fruit: FruitElement in map.find_all_fruits():
		fruit.blocked_by_dance = true
		fruit.move(opposite_dir, true)

func _enable_other_movements():
	for fruit: FruitElement in map.find_all_fruits():
		fruit.blocked_by_dance = false
	just_stopped = true
	await get_tree().process_frame
	just_stopped = false

func self_destruct():
	queue_free()

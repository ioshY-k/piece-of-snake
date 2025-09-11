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
		if current_dir%2 == 1 and (TileHelper.position_to_tile(fruit.position).x%2 == TileHelper.position_to_tile(map.snake_head.position).x%2):
			fruit.move(opposite_dir, true)
		elif current_dir%2 == 0 and (TileHelper.position_to_tile(fruit.position).y%2 == TileHelper.position_to_tile(map.snake_head.position).y%2):
			fruit.move(opposite_dir, true)

func _enable_other_movements(_tail_moves):
	for fruit: FruitElement in map.find_all_fruits():
		fruit.blocked_by_dance = false
	just_stopped = true
	await get_tree().process_frame
	just_stopped = false

func self_destruct():
	queue_free()

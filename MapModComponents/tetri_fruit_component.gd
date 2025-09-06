extends Node

var constellations: Array = [
								preload("res://MapModComponents/TetriConstellations/tetri_constellation_1.tscn"),
								preload("res://MapModComponents/TetriConstellations/tetri_constellation_2.tscn"),
								preload("res://MapModComponents/TetriConstellations/tetri_constellation_3.tscn"),
								preload("res://MapModComponents/TetriConstellations/tetri_constellation_4.tscn"),
								preload("res://MapModComponents/TetriConstellations/tetri_constellation_5.tscn")
							]
var map: Map
var tetrises: Array[Node2D]

func _ready() -> void:
	map = get_parent()
	SignalBus.fruit_collected.connect(_on_fruit_collected)
	SignalBus.next_tile_reached.connect(_check_tail_reached_tetri)

func _on_fruit_collected(_element, _is_real_collection: bool):
	if not _is_real_collection:
		return
	var tetris = constellations[randi()%constellations.size()].instantiate()
	tetrises.append(tetris)
	for child: SnakeBody in tetris.get_children():
		child.is_tetris = true
	map.add_child(tetris)
	tetris.position = TileHelper.tile_to_position(map.snake_head.next_tile)
	match map.snake_head.next_tile - map.snake_head.current_tile:
		Vector2i.UP:
			pass
		Vector2i.RIGHT:
			tetris.rotation_degrees = 90
		Vector2i.DOWN:
			tetris.rotation_degrees = 180
		Vector2i.LEFT:
			tetris.rotation_degrees = -90
	for tetris_block in tetris.get_children():
		map.temporary_obstacles.append(TileHelper.position_to_tile(map.to_local(tetris_block.global_position)))
	print(map.temporary_obstacles)
	
func _check_tail_reached_tetri():
	for tetris in tetrises:
		if TileHelper.position_to_tile(tetris.position) == TileHelper.position_to_tile(map.snake_tail.position):
			for tetris_block in tetris.get_children():
				map.temporary_obstacles.erase(TileHelper.position_to_tile(map.to_local(tetris_block.global_position)))
			tetrises.erase(tetris)
			tetris.queue_free()
	print(map.temporary_obstacles)

func self_destruct():
	for tetris in tetrises:
		for tetris_block in tetris.get_children():
			map.temporary_obstacles.erase(TileHelper.position_to_tile(map.to_local(tetris_block.global_position)))
		if is_instance_valid(tetris):
			tetris.queue_free()
	queue_free()

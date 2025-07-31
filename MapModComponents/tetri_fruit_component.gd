extends Node

var constellations: Array = [
								preload("res://MapModComponents/TetriConstellations/tetri_constellation_1.tscn"),
								preload("res://MapModComponents/TetriConstellations/tetri_constellation_2.tscn")
							]
var map: Map
var countdowns: Array[TailCountdown]
var tetrises: Array[Node2D]

func _ready() -> void:
	map = get_parent()
	SignalBus.fruit_collected.connect(_on_fruit_collected)

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
	var countdown = TailCountdown.new(map.snake_path_bodyparts.size())
	countdowns.append(countdown)
	countdown.countdown_reached.connect(_on_kill_countdown_reached.bind(tetris))

func _on_kill_countdown_reached(tetris):
	if is_instance_valid(tetris):
		countdowns.pop_front()
		tetris.queue_free()

func self_destruct():
	for tetris in tetrises:
		queue_free()
	queue_free()

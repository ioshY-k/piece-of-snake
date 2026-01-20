extends Node

@onready var tetrispawn: AudioStreamPlayer = $Tetrispawn
var constellations: Array = [
								preload("res://MapModComponents/Tetris/tetri_constellation_1.tscn"),
								preload("res://MapModComponents/Tetris/tetri_constellation_2.tscn"),
								preload("res://MapModComponents/Tetris/tetri_constellation_3.tscn"),
								preload("res://MapModComponents/Tetris/tetri_constellation_4.tscn")
							]
var map: Map
var tetrises: Array[Node2D]
enum DIRECTION {UP,RIGHT,DOWN,LEFT}

func _ready() -> void:
	map = get_parent()
	SignalBus.fruit_collected.connect(_on_fruit_collected)
	SignalBus.next_tile_reached.connect(_check_tail_reached_tetri)
	SignalBus.tail_teleported.connect(_check_tail_reached_tetri)

func _on_fruit_collected(_element, _is_real_collection: bool):
	if not _is_real_collection:
		return
	if map.snake_head.just_teleported:
		await SignalBus.next_tile_reached
		await SignalBus.next_tile_reached
		
	var tetris = constellations[randi()%constellations.size()].instantiate()
	tetrises.append(tetris)
	for child in tetris.get_children():
		if child is SnakeBody:
			child.is_tetris = true
	map.find_child("ObstacleElements").add_child(tetris)
	tetris.position = TileHelper.tile_to_position(map.snake_head.next_tile)
	match map.snake_head.current_direction:
		DIRECTION.UP:
			pass
		DIRECTION.RIGHT:
			tetris.rotation_degrees = 90
		DIRECTION.DOWN:
			tetris.rotation_degrees = 180
		DIRECTION.LEFT:
			tetris.rotation_degrees = -90
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	tween.step_finished.connect(func(_idx): 
			tetrispawn.pitch_scale = randf_range(0.7,1.3)
			tetrispawn.play())
	
	var children_reverse_order = tetris.get_children().duplicate()
	children_reverse_order.reverse()
	for tetris_block in children_reverse_order:
		map.temporary_obstacles.append(TileHelper.position_to_tile(map.to_local(tetris_block.global_position)))
		#spawn animation
		tetris_block.scale.x = 0
		tween.tween_property(tetris_block, "scale:x", 1, 0.15)
	
	
func _check_tail_reached_tetri():
	var tween = null
	var tetrises_to_erase = []
	for tetris in tetrises:
		if !is_instance_valid(tetris):
			continue
		if TileHelper.position_to_tile(tetris.get_child(-1).global_position) == TileHelper.position_to_tile(map.snake_tail.global_position):
			for tetris_block in tetris.get_children():
				map.temporary_obstacles.erase(TileHelper.position_to_tile(map.to_local(tetris_block.global_position)))
			tetrises.erase(tetris)
			tetrises_to_erase.append(tetris)
			if tween == null:
				tween = get_tree().create_tween().set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT).set_parallel(true)
				tween.step_finished.connect(func(_idx): 
					tetrispawn.pitch_scale = 0.6
					tetrispawn.play())
			tween.tween_property(tetris, "scale:x", 0, 0.2)
	if tween != null:
		await tween.finished
	for tetris in tetrises_to_erase:
		if is_instance_valid(tetris):
			tetris.queue_free()

func self_destruct():
	for tetris in tetrises:
		for tetris_block in tetris.get_children():
			map.temporary_obstacles.erase(TileHelper.position_to_tile(map.to_local(tetris_block.global_position)))
		if is_instance_valid(tetris):
			tetris.queue_free()
	queue_free()

extends MayFlyBase

func spawn_mayflies():
	map = level.current_map
	var i = 2
	while i > 0:
		var may_fly = mayfly_scene.instantiate()
		may_flies.append(may_fly)
		map.add_child(may_fly)
		may_fly.component = self
		may_fly.position = TileHelper.tile_to_position(map.free_map_tiles[randi()%map.free_map_tiles.size()-1])
		i -= 1

func set_length_to_half():
	var tail = map.snake_tail
	var tiles_to_grow = 0
	for i in range(map.snake_path_bodyparts.size()/2):
		var body = map.snake_path_bodyparts.pop_front()
		body.queue_free()
		var direction = map.snake_path_directions.pop_front()
		tiles_to_grow += 1
	tail.delayed_regrow_tiles(5, tiles_to_grow)

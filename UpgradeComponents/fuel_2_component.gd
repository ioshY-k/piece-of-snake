extends FuelBaseComponent

func apply_fruit_boni():
	if randi()%100 < 75:
		SignalBus.fruit_collected.emit(null, false)
		if level.current_map.snake_tail.tiles_to_grow > 0:
			level.current_map.snake_tail.tiles_to_grow -= 1

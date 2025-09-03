extends FuelBaseComponent


func apply_fruit_boni():
	if randi()%100 < 75:
		SignalBus.fruit_collected.emit(null, false)

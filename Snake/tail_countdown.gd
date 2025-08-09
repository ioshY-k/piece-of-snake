class_name TailCountdown extends Resource
#handles the countdown to the point where a tail reached the tile that a head
#previously went through. For example for Teleporters
var ticks: int = 1
signal countdown_reached

func _init(body_count: int) -> void:
	ticks += body_count
	SignalBus.tail_grows.connect(_tick_up)
	SignalBus.stop_moving.connect(_tick_up)
	SignalBus.next_tile_reached.connect(_tick_down)

func _tick_down():
	ticks -= 1
	if ticks == 0:
		countdown_reached.emit()
	
func _tick_up():
	ticks += 1
	if ticks == 0:
		countdown_reached.emit()

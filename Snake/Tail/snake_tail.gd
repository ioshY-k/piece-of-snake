class_name SnakeTail extends MovingSnakePart

var tiles_to_grow = 0

var snake_head: MovingSnakePart
var teleport_destination = null

func _ready() -> void:
	super._ready()
	SignalBus.teleported.connect(_on_teleported)

func _on_next_tile_reached():
	#position can only be changed in this method, cause tweens override it otherwise
	if teleport_destination != null:
		position = GameConsts.tile_to_position(teleport_destination)
		next_tile = teleport_destination
		teleport_destination = null
		
	#when not growing, delete last snake body and direction path, then follow given direction
	if tiles_to_grow == 0 and snake_head.moves:
		current_tile = next_tile
		map.pop_snake_bodyparts()
		current_direction = map.pop_snake_directions()
		next_tile = map.get_next_tile(current_tile, current_direction)
	#otherwise stand still and grow
	elif snake_head.moves:
		tiles_to_grow -= 1
		SignalBus.tail_grows.emit()

	get_moving_tween(true)
	get_turning_tween(current_direction)
	
	SignalBus.continue_moving.emit()

func _on_teleported(destination: Vector2i):
	var countdown: TailCountdown = TailCountdown.new(get_parent().snake_path_bodyparts.size())
	await countdown.countdown_reached
	teleport_destination = destination

func _on_stop_moving():
	pass
func _on_continue_moving():
	pass
	
#handles the countdown to the point where a tail reached the tile that a head
#previously went through. For example for Teleporters
class TailCountdown:
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

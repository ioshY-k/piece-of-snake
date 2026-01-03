extends Node

const TILE_SIZE = 80
enum DIRECTION {UP,RIGHT,DOWN,LEFT,STOP,DISAPPEAR,APPEAR}
var calls_per_frame: int = 0

func _process(delta: float) -> void:
	calls_per_frame = 0

#calculates the tile vector to the left/right/top/bottom of a given field
func get_next_tile(current_tile: Vector2i, direction) -> Vector2i:
	calls_per_frame += 1
	match direction:
		DIRECTION.UP:
			return Vector2i(current_tile.x, current_tile.y-1)
		DIRECTION.RIGHT:
			return Vector2i(current_tile.x+1, current_tile.y)
		DIRECTION.DOWN:
			return Vector2i(current_tile.x, current_tile.y+1)
		DIRECTION.LEFT:
			return Vector2i(current_tile.x-1, current_tile.y)
		DIRECTION.STOP,\
		DIRECTION.DISAPPEAR,\
		DIRECTION.APPEAR:
			return Vector2i(current_tile.x, current_tile.y)
		_:
			return Vector2i.ZERO

func get_opposite(direction):
	match direction:
		DIRECTION.UP:
			return DIRECTION.DOWN
		DIRECTION.RIGHT:
			return DIRECTION.LEFT
		DIRECTION.DOWN:
			return DIRECTION.UP
		DIRECTION.LEFT:
			return DIRECTION.RIGHT
		DIRECTION.STOP,\
		DIRECTION.DISAPPEAR,\
		DIRECTION.APPEAR:
			return DIRECTION.STOP
		_:
			return 

#converts a tile vector to it's actual position
func tile_to_position(tile: Vector2i) -> Vector2:
	return tile * TILE_SIZE

#converts a position to its tile vector
func position_to_tile(pos: Vector2) -> Vector2i:
	var tileval = round(pos / TILE_SIZE)
	return tileval

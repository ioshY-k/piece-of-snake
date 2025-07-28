extends Node

const TILE_SIZE = 80
enum DIRECTION {UP,RIGHT,DOWN,LEFT,STOP,DISAPPEAR,APPEAR}

#calculates the tile vector to the left/right/top/bottom of a given field
func get_next_tile(current_tile: Vector2i, direction) -> Vector2i:
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

#converts a tile vector to it's actual position
func tile_to_position(tile: Vector2i) -> Vector2:
	return tile * TILE_SIZE

#converts a position to its tile vector
func position_to_tile(pos: Vector2) -> Vector2i:
	var tileval = round(pos / TILE_SIZE)
	return tileval

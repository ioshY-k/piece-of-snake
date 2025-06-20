extends Node


const SPEED_BOOST_SPEED = 0.15
const NORMAL_SPEED = 0.38
const TILE_SIZE = 80

enum UPGRADE_LIST {FRUIT_MAGNET_1, FRUIT_RELOCATOR_1, HYPER_SPEED_1, FRUIT_MAGNET_2}
const FRUIT_THRESHOLDS: Array [int] = [1,1,1,1, 1,1,1,1]
const ROUND_TIME_SEC: int = 5

var node_being_dragged: Node = null

#converts a tile vector to it's actual position
func tile_to_position(tile: Vector2i) -> Vector2:
	return tile * TILE_SIZE

#converts a position to its tile vector
func position_to_tile(pos: Vector2) -> Vector2i:
	var tileval = round(pos / TILE_SIZE)
	return tileval

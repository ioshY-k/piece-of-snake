extends Node


const SPEED_BOOST_SPEED = 0.15
const NORMAL_SPEED = 0.38
const TILE_SIZE = 80

enum UPGRADE_TYPE {DEFAULT, PASSIVE, BODYMOD, SYNERGY, ACTIVE, SPECIAL}
enum UPGRADE_LIST {	AREA_SIZE_1, AREA_SIZE_2, AREA_SIZE_3,
					FRUIT_MAGNET_1, FRUIT_MAGNET_2, FRUIT_MAGNET_3,
					HYPER_SPEED_1, HYPER_SPEED_2, HYPER_SPEED_3,
					DOUBLE_FRUIT_1, DOUBLE_FRUIT_2, DOUBLE_FRUIT_3,
					EDGE_WRAP_1, EDGE_WRAP_2, 
					FRUIT_RELOCATOR_1, FRUIT_RELOCATOR_2, FRUIT_RELOCATOR_3,
					CROSS_ROAD_1, CROSS_ROAD_2, CROSS_ROAD_3,
					TAIL_CUT,
					KNOT_ATTRACTOR,
					ITEM_RELOADER,
					IMMUTABLE}

					
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

func get_upgrade_type(upgrade_id: int):
	
	match upgrade_id:
		0,1,2:
			return UPGRADE_TYPE.DEFAULT
		3,4,5,6,7,8,9,10,11,12,13:
			return UPGRADE_TYPE.PASSIVE
		14,15,16,17,18,19:
			return UPGRADE_TYPE.ACTIVE
		20:
			return UPGRADE_TYPE.BODYMOD
		21,22:
			return UPGRADE_TYPE.SYNERGY
		23:
			return UPGRADE_TYPE.SPECIAL
		_:
			print_debug("notype has been found for this upgrade: " + str(upgrade_id))

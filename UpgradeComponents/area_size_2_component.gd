extends Node

func _ready() -> void:
	var level: LevelManager = get_parent()
	level.current_map.position = level.map_third_pos_and_scale[level.current_map_index][0]
	level.current_map.scale = level.map_third_pos_and_scale[level.current_map_index][1]
	for solid_element in level.current_map.get_node("AreaSize2SolidElements").get_children():
		level.current_map.update_free_map_tiles(GameConsts.position_to_tile(solid_element.position))
		solid_element.queue_free()
func self_destruct():
	queue_free()

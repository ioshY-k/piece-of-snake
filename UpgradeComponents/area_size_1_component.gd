extends Node

func _ready() -> void:
	var level: LevelManager = get_parent()
	var map_id = level.current_map_index
	level.current_map.inbounds_grid_size = MapData.get_map_data1(map_id)[2]
	level.current_map.zoom_state = 1
	await SignalBus.round_started
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_property(level.current_map, "position", MapData.get_map_data1(map_id)[0], 0.8)
	tween.tween_property(level.current_map, "scale", MapData.get_map_data1(map_id)[1], 0.8)
	
	for solid_element in level.current_map.get_node("AreaSize1SolidElements").get_children():
		level.current_map.update_free_map_tiles(TileHelper.position_to_tile(solid_element.position))
		solid_element.queue_free()
	

func self_destruct():
	queue_free()

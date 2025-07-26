extends MapData

func _ready() -> void:
	var level: LevelManager = get_parent()
	level.current_map.inbounds_grid_size = map_data_size2[level.current_map_index][2]
	level.current_map.zoom_state = 2
	await SignalBus.round_started
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_property(level.current_map, "position", map_data_size2[level.current_map_index][0], 0.8)
	tween.tween_property(level.current_map, "scale", map_data_size2[level.current_map_index][1], 0.8)

	for solid_element in level.current_map.get_node("AreaSize2SolidElements").get_children():
		level.current_map.update_free_map_tiles(TileHelper.position_to_tile(solid_element.position))
		solid_element.queue_free()
		
func self_destruct():
	queue_free()

extends Node

func _ready() -> void:
	var level: LevelManager = get_parent()
	await level.round_started
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_parallel()
	tween.tween_property(level.current_map, "position", level.map_fourth_pos_and_scale[level.current_map_index][0], 0.8)
	tween.tween_property(level.current_map, "scale", level.map_fourth_pos_and_scale[level.current_map_index][1], 0.8)
	for solid_element in level.current_map.get_node("AreaSize3SolidElements").get_children():
		level.current_map.update_free_map_tiles(GameConsts.position_to_tile(solid_element.position))
		solid_element.queue_free()
func self_destruct():
	queue_free()

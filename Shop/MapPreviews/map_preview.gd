class_name MapPreview extends Sprite2D

func set_map_preview(preview_index: int, map: int):
	get_child(preview_index).frame = map

func set_map_covering(preview_index: int):
	for i in range (preview_index+1):
		get_child(i).get_node("Covering").hide()
		
func set_round_indicators(current_act, current_round):
	for act in range(current_act):
		get_child(act).get_node("RoundIndicator").frame = 4
	get_child(current_act).get_node("RoundIndicator").frame = 1
	for round in range(current_round):
		get_child(current_act).get_node("RoundIndicator").frame = round+2

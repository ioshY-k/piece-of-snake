extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(6):
		area.set_collision_layer_value(6,false)
	else:
		area.set_collision_layer_value(6,true)

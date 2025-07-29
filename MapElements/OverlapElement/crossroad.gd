extends Sprite2D


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is SnakeBody:
		area.get_parent().set_overlap(true)

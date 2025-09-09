class_name Darkness extends Area2D

var map:Map

func _get_banished():
	map = get_parent()
	var flee_direction = (map.snake_head.position - position).rotated(rad_to_deg(180)).normalized()
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", position + flee_direction * 200, 0.5)

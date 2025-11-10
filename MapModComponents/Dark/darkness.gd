class_name Darkness extends Area2D

var map:Map
var banished: bool

func _get_banished():
	if banished:
		return
	banished = true
	map = get_parent()
	var flee_direction = (map.snake_head.position - position).rotated(deg_to_rad(180)).rotated(deg_to_rad(randi_range(-40,40))).normalized()
	var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", position + flee_direction * 200, 0.5)
	await tween.finished
	banished = false

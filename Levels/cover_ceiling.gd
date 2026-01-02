@tool
extends Sprite2D

@export var sprite:Texture2D:
	set(value):
		sprite = value
		texture = value

@onready var area_2d: Area2D = $Area2D
@onready var collision_polygon_2d: CollisionPolygon2D = $Area2D/CollisionPolygon2D

func _ready() -> void:
	if is_in_group("Spinning Ceiling"):
		var tween = get_tree().create_tween().set_loops().set_trans(Tween.TRANS_LINEAR)
		tween.tween_property(self, "rotation_degrees", 360, 10)
		tween.loop_finished.connect(func(_loop): rotation_degrees = 0)

func _on_area_2d_area_entered(area: Area2D) -> void:
	var tween:Tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "modulate:a", 0.1, 0.4)



func _on_area_2d_area_exited(area: Area2D) -> void:
	var tween:Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 0.4).set_trans(Tween.TRANS_LINEAR)

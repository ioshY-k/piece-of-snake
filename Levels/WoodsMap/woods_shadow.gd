extends Sprite2D

func _ready() -> void:
	if randi() % 2 == 0:
		scale.x = -1
	
	if randi() % 2 == 0:
		scale.y = -1
	$AnimationPlayer.play("shadow_move_anim")

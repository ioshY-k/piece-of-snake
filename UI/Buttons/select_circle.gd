class_name SelectCircle extends AnimatedSprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_active = true

func appear():
	is_active = true
	play("Appear")
	animation_player.play("Spin_in")
	await animation_player.animation_finished
	if is_active:
		animation_player.play("Spin")

func disappear():
	is_active = false
	play_backwards("Appear")
	animation_player.play("Spin_out")

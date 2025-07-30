class_name Laser extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("laser")

func _on_animplayer_kill():
	print("killedbyanimation")
	queue_free()

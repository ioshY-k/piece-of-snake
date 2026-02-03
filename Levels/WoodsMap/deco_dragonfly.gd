extends AnimatedSprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.animation_finished.connect(func(_var): play("default"))

func _on_area_2d_area_entered(area: Area2D) -> void:
	play("fly")
	animation_player.play("fly_around")
	

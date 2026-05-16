extends Sprite2D

var opacity = 0.0

func _ready() -> void:
	self_modulate.a = randf_range(0.6,0.9)
	scale.x = randf_range(0.1,0.25)
	scale.y = randf_range(0.1,0.15)

func _process(delta: float) -> void:
	modulate.a = lerp(modulate.a , opacity, randf_range(0.05,0.25))
	if modulate.a < opacity + 0.01 and modulate.a > opacity - 0.01:
		if opacity == 0.0:
			opacity = randf_range(0.4,0.8)
		else:
			opacity = 0.0

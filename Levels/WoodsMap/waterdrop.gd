extends Sprite2D

var opacity = 0.0
var jitterplace = Vector2(randf_range(0.0,10.0),randf_range(0.0,10.0))

func _ready() -> void:
	self_modulate.a = randf_range(0.6,0.9)
	scale.x = randf_range(0.1,0.25)
	scale.y = randf_range(0.1,0.15)

func _process(delta: float) -> void:
	modulate.a = lerp(modulate.a , opacity, randf_range(0.05,0.25))
	position.x = lerp(position.x , jitterplace.x, randf_range(0.3,1.0))
	position.y = lerp(position.y , jitterplace.y, randf_range(0.3,1.0))
	if modulate.a < opacity + 0.01 and modulate.a > opacity - 0.01:
		if opacity == 0.0:
			opacity = randf_range(0.4,0.8)
		else:
			opacity = 0.0
	if position.x < jitterplace.x + 0.1 and position.x > jitterplace.x - 0.1:
		jitterplace = Vector2(randf_range(0.0,10.0),randf_range(0.0,10.0))

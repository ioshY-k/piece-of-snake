extends Sprite2D

@export var deco_sprite: Texture2D
@export_enum("Grow","GrowInverse", "Dance", "DanceInverse", "Hop") var animation: String = "Grow"
@export var scaling: float = 1.0

func _ready() -> void:
	texture = deco_sprite
	scale = Vector2(scaling, scaling)
	create_animation()

func create_animation():
	var tween: Tween = create_tween().set_loops()
	match animation:
		"Grow":
			tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(self, "scale", scale + Vector2(0.2,0.2), 0.63)
			tween.tween_property(self, "scale", scale + Vector2(0.2,0.2), 0.63)
			tween.tween_property(self, "scale", scale - Vector2(0.2,0.2), 0.63)
			tween.tween_property(self, "scale", scale - Vector2(0.2,0.2), 0.63)
		"GrowInverse":
			tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(self, "scale", scale - Vector2(0.2,0.2), 0.63)
			tween.tween_property(self, "scale", scale - Vector2(0.2,0.2), 0.63)
			tween.tween_property(self, "scale", scale + Vector2(0.2,0.2), 0.63)
			tween.tween_property(self, "scale", scale + Vector2(0.2,0.2), 0.63)
		"Dance":
			tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(self, "rotation", rotation + 0.15, 0.63)
			tween.tween_property(self, "rotation", rotation + 0.15, 0.63)
			tween.tween_property(self, "rotation", rotation - 0.15, 0.63)
			tween.tween_property(self, "rotation", rotation - 0.15, 0.63)
		"DanceInverse":
			tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(self, "rotation", rotation - 0.15, 0.63)
			tween.tween_property(self, "rotation", rotation - 0.15, 0.63)
			tween.tween_property(self, "rotation", rotation + 0.15, 0.63)
			tween.tween_property(self, "rotation", rotation + 0.15, 0.63)
			
	tween.step_finished.connect(func(_steps):
		tween.pause()
		await SignalBus.next_tile_reached
		tween.play())

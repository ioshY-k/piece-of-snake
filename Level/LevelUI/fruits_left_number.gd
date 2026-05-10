extends Label

func _ready() -> void:
	SignalBus.got_hit_and_punished.connect(_on_hit)
	SignalBus.fruit_collected.connect(_on_collect)

func _on_hit():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(1.0, 0.4, 0.4), 0.05)
	tween.tween_property(self, "position:y", position.y + 10, 0.1)
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.5, 0.1)
	tween.set_parallel(false)
	tween.tween_property(self, "position:y", position.y, 0.1)
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1, 0.1)
	tween.set_parallel(false)
	tween.tween_property(self, "modulate", Color(1.0, 1.0,1.0), 0.05)
	
func _on_collect(_fruit, _real_collection):
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(0.612, 0.694, 0.91), 0.05)
	tween.tween_property(self, "position:y", position.y - 10, 0.1)
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.5, 0.1)
	tween.set_parallel(false)
	tween.tween_property(self, "position:y", position.y, 0.1)
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1, 0.1)
	tween.set_parallel(false)
	tween.tween_property(self, "modulate", Color(1.0, 1.0,1.0), 0.05)
	

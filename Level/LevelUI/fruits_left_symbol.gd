extends Sprite2D

@onready var hit_particles: CPUParticles2D = $HitParticles
@onready var collect_particles: CPUParticles2D = $CollectParticles

func _ready() -> void:
	SignalBus.got_hit_and_punished.connect(_on_hit)
	SignalBus.fruit_collected.connect(_on_collect)

func _on_hit():
	hit_particles.emitting = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate", Color(1.0, 0.4, 0.4), 0.05)
	tween.tween_property(self, "position:x", position.x - 10, 0.06)
	tween.tween_property(self, "position:x", position.x, 0.06)
	tween.tween_property(self, "position:x", position.x + 10, 0.06)
	tween.tween_property(self, "position:x", position.x, 0.06)
	tween.tween_property(self, "self_modulate", Color(1.0, 0.4, 0.4), 0.2)
	tween.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0), 0.2)

func _on_collect(_fruit, _real_collection):
	collect_particles.emitting = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate", Color(0.612, 0.694, 0.91), 0.05)
	tween.tween_property(self, "scale", Vector2(0.4,0.4), 0.12)
	tween.tween_property(self, "scale", Vector2(0.275,0.275), 0.12)
	tween.tween_property(self, "self_modulate", Color(0.612, 0.694, 0.91), 0.2)
	tween.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0), 0.2)

extends Node2D

@onready var kill_timer: Timer = $KillTimer
@onready var slime_particles: CPUParticles2D = $SlimeParticles
@onready var slime_trail_area: Area2D = $SlimeTrailArea

var level: LevelManager

func _ready() -> void:
	level = get_parent().get_parent()
	slime_particles.one_shot = true
	kill_timer.timeout.connect(_kill_slime_trail)


func _on_slime_trail_area_area_entered(area: Area2D) -> void:
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(level.speed_boost_bar, "value", 0, 0.3)

func _kill_slime_trail():
	slime_trail_area.set_collision_layer_value(14, false)
	await get_tree().create_timer(0.5).timeout
	queue_free()

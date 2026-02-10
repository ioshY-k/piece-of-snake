extends Node

var map: Map
@onready var anti_magnet_audio: AudioStreamPlayer = $AntiMagnetAudio
const ANTI_MAGNET_PARTICLES = preload("res://MapModComponents/AntiMagnet/anti_magnet_particles.tscn")
var particles: CPUParticles2D

func _ready() -> void:
	map = get_parent()
	particles = ANTI_MAGNET_PARTICLES.instantiate()
	map.snake_head.add_child(particles)
	SignalBus.stop_moving.connect(_push_fruit_away)

func _push_fruit_away(_tail_moves):
	for fruit:FruitElement in get_tree().get_nodes_in_group("Fruit"):
		fruit.move(fruit.move_type.AWAY, false)
	if not anti_magnet_audio.playing:
		particles.emitting = true
		anti_magnet_audio.play()
		

func self_destruct():
	particles.queue_free()
	queue_free()

extends Node2D

@onready var tail_virus_particles: CPUParticles2D = $TailVirusParticles

func _ready() -> void:
	SignalBus.next_tile_reached.connect(_emit_particles)
	
func _emit_particles():
	tail_virus_particles.restart()

func self_destruct():
	queue_free()

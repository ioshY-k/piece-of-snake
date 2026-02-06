extends Node2D
@onready var cpu_particles_2dl: CPUParticles2D = $LeftGun1/LeftGun2/LeftGun3/CPUParticles2D
@onready var cpu_particles_2dc: CPUParticles2D = $CenterGun1/CenterGun2/CenterGun3/CPUParticles2D
@onready var cpu_particles_2dr: CPUParticles2D = $RightGun1/RightGun2/RightGun3/CPUParticles2D
@onready var shoot_timer: Timer = $ShootTimer

func _ready() -> void:
	shoot_timer.timeout.connect(shoot)

func shoot():
	var lasershots: Array[CPUParticles2D] = [cpu_particles_2dc, cpu_particles_2dl, cpu_particles_2dr]
	var shot = lasershots[randi()%3]
	shot.emitting = true
	shoot_timer.start(randf_range(0.6,1.6))

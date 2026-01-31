class_name Laser extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var particles_laser_bubble_2: CPUParticles2D = $ParticlesLaserBubble2
@onready var particles_laser_bubble_1: CPUParticles2D = $ParticlesLaserBubble1
@onready var particles_warning: CPUParticles2D = $ParticlesWarning
@onready var particles_laser: CPUParticles2D = $ParticlesLaser
@onready var laser_sound: AudioStreamPlayer = $LaserSound


func _ready() -> void:
	animation_player.play("laser")
	laser_sound.play()

func _on_animplayer_kill():
	await get_tree().create_timer(1).timeout
	queue_free()

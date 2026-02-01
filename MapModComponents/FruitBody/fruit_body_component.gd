extends Node

var map: Map
@onready var scale_audio: AudioStreamPlayer = $ScaleAudio

func _ready() -> void:
	map = get_parent()
	SignalBus.overlapped.connect(_on_overlap)

func _on_overlap():
	scale_audio.play()
	var position = TileHelper.tile_to_position(map.snake_head.next_tile)
	var obstacle_element = load("res://MapElements/ObstacleElement/obstacle_element.tscn").instantiate()
	var obstacle_hitbox_element = load("res://MapElements/ObstacleElement/obstacle_hitbox_element.tscn").instantiate()
	var fruit_body_particles: CPUParticles2D = load("res://MapModComponents/FruitBody/fruit_body_particles.tscn").instantiate()
	map.add_child(fruit_body_particles)
	map.add_child(obstacle_element)
	map.add_child(obstacle_hitbox_element)
	fruit_body_particles.position = position
	fruit_body_particles.emitting = true
	obstacle_element.position = position
	obstacle_hitbox_element.position = position
	map.update_free_map_tiles(map.snake_head.next_tile, false)
	obstacle_element.modulate.a = 0
	var tween = get_tree().create_tween()
	tween.tween_property(obstacle_element, "modulate:a", 0.01, 1)
	tween.tween_property(obstacle_element, "modulate:a", 1, 0.4)

func self_destruct():
	queue_free()

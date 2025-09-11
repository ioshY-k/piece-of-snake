class_name Teleporter extends Area2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@export var destination_tile: Vector2i
var one_use = false
var map:Map

func _ready() -> void:
	map = get_node("/root/MainSceneLoader/RunManager/Level/Map")
	if one_use:
		SignalBus.next_tile_reached.connect(_check_if_destroyed)
	else:
		$TeleporterEncasing.queue_free()

func _check_if_destroyed():
	if TileHelper.position_to_tile(map.snake_tail.position) == TileHelper.position_to_tile(position):
		SignalBus.teleport_finished.emit(self)
		queue_free()
	

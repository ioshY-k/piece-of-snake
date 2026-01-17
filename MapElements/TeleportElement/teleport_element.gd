class_name Teleporter extends Area2D

const OBSTACLE_ELEMENT = preload("res://MapElements/ObstacleElement/obstacle_element.tscn")
const OBSTACLE_HITBOX_ELEMENT = preload("res://MapElements/ObstacleElement/obstacle_hitbox_element.tscn")
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@export var destination_tile: Vector2i
var one_use = false
var destination_obstacle = null
var destination_obstacle_hitbox = null
var map:Map

func _ready() -> void:
	map = get_node("/root/MainSceneLoader/RunManager/Level/Map")
	if one_use:
		SignalBus.tail_teleported.connect(_check_if_destroyed)
		destination_obstacle = OBSTACLE_ELEMENT.instantiate()
		map.obstacle_elements.add_child(destination_obstacle)
		destination_obstacle.z_index = 21
		destination_obstacle.position = TileHelper.tile_to_position(destination_tile)
		destination_obstacle_hitbox = OBSTACLE_HITBOX_ELEMENT.instantiate()
		map.obstacle_elements.add_child(destination_obstacle_hitbox)
		destination_obstacle_hitbox.position = TileHelper.tile_to_position(destination_tile)
		map.update_free_map_tiles(destination_tile, false)
	else:
		$TeleporterEncasing.queue_free()

func _check_if_destroyed():
	if TileHelper.position_to_tile(map.snake_tail.position) == destination_tile:
		SignalBus.teleport_finished.emit(self)
		map.update_free_map_tiles(destination_tile, true)
		if destination_obstacle != null:
			destination_obstacle.queue_free()
		if destination_obstacle_hitbox != null:
			destination_obstacle_hitbox.queue_free()
		queue_free()


func disable():
	cpu_particles_2d.hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	
func enable():
	cpu_particles_2d.show()
	process_mode = Node.PROCESS_MODE_INHERIT

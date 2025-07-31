extends Node

var map: Map
var current_laser: Laser
var laser_scene = load("res://MapModComponents/laser.tscn")
@onready var laser_timer: Timer = $LaserTimer


func _ready() -> void:
	map = get_parent()
	laser_timer.timeout.connect(spawn_laser)

func spawn_laser():
	print("spawn laser")
	current_laser = laser_scene.instantiate()
	map.add_child(current_laser)
	if randi()%2 == 0:
		current_laser.position = TileHelper.tile_to_position(Vector2i(map.inbounds_grid_size.x/2, randi()%map.inbounds_grid_size.y)) 
	else:
		current_laser.rotation_degrees = 90
		current_laser.position = TileHelper.tile_to_position(Vector2i(randi()%map.grid_size.x, map.grid_size.y/2)) 

func self_destruct():
	queue_free()

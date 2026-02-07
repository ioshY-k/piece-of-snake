extends Node

var map: Map
var current_laser: Laser
var laser_scene = load("res://MapModComponents/Laser/laser.tscn")
@onready var laser_timer: Timer = $LaserTimer


func _ready() -> void:
	map = get_parent()
	laser_timer.timeout.connect(spawn_laser)

func spawn_laser():
	current_laser = laser_scene.instantiate()
	map.add_child(current_laser)
	if randi()%2 == 0:
		var top_bound = MapData.call_map_data_at_zoom(map.zoom_state, map.get_parent().current_map_index)[3].y
		var bottom_bound = MapData.call_map_data_at_zoom(map.zoom_state, map.get_parent().current_map_index)[4].y
		var pos_y = randi_range(top_bound+1, bottom_bound-1)
		current_laser.position = TileHelper.tile_to_position(Vector2i(map.inbounds_grid_size.x/2,pos_y))
	else:
		current_laser.rotation_degrees = 90
		current_laser.particles_warning.angle_min = 90
		current_laser.particles_warning.angle_max = 90
		current_laser.particles_laser.angle_min = 90
		current_laser.particles_laser.angle_max = 90
		var left_bound = MapData.call_map_data_at_zoom(map.zoom_state, map.get_parent().current_map_index)[3].x
		var right_bound = MapData.call_map_data_at_zoom(map.zoom_state, map.get_parent().current_map_index)[4].x
		var pos_x = randi_range(left_bound+1, right_bound-1)
		current_laser.position = TileHelper.tile_to_position(Vector2i(pos_x, map.inbounds_grid_size.y/2)) 

func self_destruct():
	queue_free()

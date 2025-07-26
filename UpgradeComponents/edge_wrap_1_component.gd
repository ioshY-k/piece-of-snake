extends MapData

var teleport_element_scene = load("res://MapElements/TeleportElement/teleport_element.tscn")
var teleporters: Array[Teleporter] = []

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	SignalBus.round_started.connect(place_teleporters)
	place_teleporters()
		
func place_teleporters():
	var map: Map = get_parent()
	var map_data_array
	match map.zoom_state:
		0:
			map_data_array = map_data_size0
		1:
			map_data_array = map_data_size1
		2:
			map_data_array = map_data_size2
		3:
			map_data_array = map_data_size3
	var upper_left_corner = map_data_array[map.get_parent().current_map_index][3]
	var lower_right_corner = map_data_array[map.get_parent().current_map_index][4]
	
	for tele in teleporters:
		tele.queue_free()
	teleporters = []
	
	
	#place a teleporter at every out of bounds tile surrounding the map
	for x in range(upper_left_corner.x+1, lower_right_corner.x):
		var teleporter: Teleporter = teleport_element_scene.instantiate()
		get_parent().add_child(teleporter)
		teleporter.rotation_degrees = 180
		teleporter.position = TileHelper.tile_to_position(Vector2i(x,upper_left_corner.y))
		teleporter.destination_tile = Vector2i(x,lower_right_corner.y)
		teleporters.append(teleporter)
		teleporter = teleport_element_scene.instantiate()
		get_parent().add_child(teleporter)
		teleporter.position = TileHelper.tile_to_position(Vector2i(x,lower_right_corner.y))
		teleporter.destination_tile = Vector2i(x,upper_left_corner.y)
		teleporters.append(teleporter)
	for y in range(upper_left_corner.y+1, lower_right_corner.y):
		var teleporter: Teleporter = teleport_element_scene.instantiate()
		get_parent().add_child(teleporter)
		teleporter.rotation_degrees = 90
		teleporter.position = TileHelper.tile_to_position(Vector2i(upper_left_corner.x,y))
		teleporter.destination_tile = Vector2i(lower_right_corner.x,y)
		teleporters.append(teleporter)
		teleporter = teleport_element_scene.instantiate()
		get_parent().add_child(teleporter)
		teleporter.rotation_degrees = -90
		teleporter.position = TileHelper.tile_to_position(Vector2i(lower_right_corner.x,y))
		teleporter.destination_tile = Vector2i(upper_left_corner.x,y)
		teleporters.append(teleporter)
		

func self_destruct():
	queue_free()

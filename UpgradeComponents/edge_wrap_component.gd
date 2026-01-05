extends Node

var teleport_element_scene = load("res://MapElements/TeleportElement/teleport_element.tscn")
var teleporters: Array[Teleporter] = []
var map:Map
var is_retro_ability: bool = false

func instantiate_as_retro_ability():
	is_retro_ability = true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	map = get_parent()
	
	if not RunSettings.current_char == GameConsts.CHAR_LIST.RETRO or (RunSettings.current_char == GameConsts.CHAR_LIST.RETRO and is_retro_ability):
		SignalBus.round_started.connect(place_teleporters)
		place_teleporters()
	
	if not is_retro_ability:
		for teleporter in map.get_node("TeleportElements").get_children():
			if not teleporter.is_in_group("Edge Wrap Teleporter"):
				teleporter.disable()
		
func place_teleporters():
	#so that area size first removes the surrounding tiles
	await get_tree().process_frame
	var map: Map = get_parent()
	
	var map_data_array
	match map.zoom_state:
		0:
			map_data_array = MapData.get_map_data0(map.get_parent().current_map_index)
		1:
			map_data_array = MapData.get_map_data1(map.get_parent().current_map_index)
		2:
			map_data_array = MapData.get_map_data2(map.get_parent().current_map_index)
		3:
			map_data_array = MapData.get_map_data3(map.get_parent().current_map_index)
	var upper_left_corner = map_data_array[3]
	var lower_right_corner = map_data_array[4]
	
	for tele in teleporters:
		tele.queue_free()
	teleporters = []
	
	
	#place a teleporter at every out of bounds tile surrounding the map
	for x in range(upper_left_corner.x+1, lower_right_corner.x):
		var teleporter: Teleporter = teleport_element_scene.instantiate()
		get_parent().add_child(teleporter)
		teleporter.add_to_group("Edge Wrap Teleporter")
		teleporter.rotation_degrees = 180
		teleporter.position = TileHelper.tile_to_position(Vector2i(x,upper_left_corner.y))
		teleporter.destination_tile = Vector2i(x,lower_right_corner.y)
		if not map.free_map_tiles.has(TileHelper.get_next_tile(teleporter.destination_tile, TileHelper.DIRECTION.UP)):
			teleporter.cpu_particles_2d.color = Color(0.93, 0.344, 0.354, 0.322)
		teleporters.append(teleporter)
		teleporter = teleport_element_scene.instantiate()
		get_parent().add_child(teleporter)
		teleporter.add_to_group("Edge Wrap Teleporter")
		teleporter.position = TileHelper.tile_to_position(Vector2i(x,lower_right_corner.y))
		teleporter.destination_tile = Vector2i(x,upper_left_corner.y)
		if not map.free_map_tiles.has(TileHelper.get_next_tile(teleporter.destination_tile, TileHelper.DIRECTION.DOWN)):
			teleporter.cpu_particles_2d.color = Color(0.93, 0.344, 0.354, 0.322)
		teleporters.append(teleporter)
	for y in range(upper_left_corner.y+1, lower_right_corner.y):
		var teleporter: Teleporter = teleport_element_scene.instantiate()
		get_parent().add_child(teleporter)
		teleporter.add_to_group("Edge Wrap Teleporter")
		teleporter.rotation_degrees = 90
		teleporter.position = TileHelper.tile_to_position(Vector2i(upper_left_corner.x,y))
		teleporter.destination_tile = Vector2i(lower_right_corner.x,y)
		if not map.free_map_tiles.has(TileHelper.get_next_tile(teleporter.destination_tile, TileHelper.DIRECTION.LEFT)):
			teleporter.cpu_particles_2d.color = Color(0.93, 0.344, 0.354, 0.322)
		teleporters.append(teleporter)
		teleporter = teleport_element_scene.instantiate()
		get_parent().add_child(teleporter)
		teleporter.add_to_group("Edge Wrap Teleporter")
		teleporter.rotation_degrees = -90
		teleporter.position = TileHelper.tile_to_position(Vector2i(lower_right_corner.x,y))
		teleporter.destination_tile = Vector2i(upper_left_corner.x,y)
		if not map.free_map_tiles.has(TileHelper.get_next_tile(teleporter.destination_tile, TileHelper.DIRECTION.RIGHT)):
			teleporter.cpu_particles_2d.color = Color(0.93, 0.344, 0.354, 0.322)
		teleporters.append(teleporter)
	await get_tree().process_frame
		

func self_destruct():
	for teleporter in map.get_node("TeleportElements").get_children():
		if not teleporter.is_in_group("Edge Wrap Teleporter"):
			teleporter.enable()
	if RunSettings.current_char != GameConsts.CHAR_LIST.RETRO:
		for teleporter in teleporters:
			teleporter.queue_free()
	queue_free()

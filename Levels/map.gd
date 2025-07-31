class_name Map extends Sprite2D

#temporary instatiated map elements
var snake_body_scene = load("res://Snake/Body/snake_body.tscn")
var snake_head_scene = preload("res://Snake/Head/snake_head.tscn")
var snake_tail_scene = preload("res://Snake/Tail/snake_tail.tscn")
var fruit_element_scene = load("res://MapElements/FruitElements/fruit_element.tscn")
var teleport_element_scene = load("res://MapElements/TeleportElement/teleport_element.tscn")

#instantiated upgrade components
var fruit_magnet_1_component_scene = load("res://UpgradeComponents/fruit_magnet_1_component.tscn")
var fruit_magnet_2_component_scene = load("res://UpgradeComponents/fruit_magnet_2_component.tscn")
var fruit_magnet_3_component_scene = load("res://UpgradeComponents/fruit_magnet_3_component.tscn")
var double_fruit_1_component_scene = load("res://UpgradeComponents/double_fruit_1_component.tscn")
var double_fruit_2_component_scene = load("res://UpgradeComponents/double_fruit_2_component.tscn")
var double_fruit_3_component_scene = load("res://UpgradeComponents/double_fruit_3_component.tscn")
var edge_wrap_1_component_scene = load("res://UpgradeComponents/edge_wrap_1_component.tscn")
var corner_phasing_scene = load("res://UpgradeComponents/corner_phasing_component.tscn")
var anchor_component_scene = load("res://UpgradeComponents/anchor_component.tscn")

#mapmods
var caffeinated_component_scene = load("res://MapModComponents/caffeinated_component.tscn")
var tailvirus_component_scene = load("res://MapModComponents/tail_virus_component.tscn")
var edible_paper_component_scene = load("res://MapModComponents/edible_paper_component.tscn")
var laser_component_scene = load("res://MapModComponents/laser_component.tscn")
var fruit_body_component_scene = load("res://MapModComponents/fruit_body_component.tscn")
var tetri_fruit_component_scene = load("res://MapModComponents/tetri_fruit_component.tscn")

#permanent snake parts
@onready var snake_head: SnakeHead
@onready var snake_tail: SnakeTail

#map data
@export var grid_size: Vector2i
@export var inbounds_grid_size: Vector2i
@export var starting_position: Vector2
var zoom_state: int = 0 #0 by default and +1 for each area size upgrade
var fruit_locations: Array[Vector2i]


#arrays containing Snake data for the tail to follow
enum DIRECTION {UP,RIGHT,DOWN,LEFT,STOP}
var snake_path_directions: Array[int] = [DIRECTION.UP, DIRECTION.UP, DIRECTION.UP, DIRECTION.UP]
var snake_path_bodyparts: Array[SnakeBody]

#array containing constantly free tiles for fruits to spawn in
var free_map_tiles: Array[Vector2i]

var invincible_ticks = 0

#making sure map initializes before snake
signal initialized
#making sure the level catches the signal before the map does, since map gives iframes
signal snake_got_hit

func _ready() -> void:
	#change the seed for randomness
	randomize()
	
	#set up attributes
	starting_position = starting_position * GameConsts.TILE_SIZE
	free_map_tiles = find_free_map_tiles()
	
	#place fruit and player
	teleport_to_starting_position()
	snake_head.snake_tail = snake_tail
	snake_tail.snake_head = snake_head
	spawn_fruit([])
	
	SignalBus.round_over.connect(_on_round_over)
	SignalBus.next_tile_reached.connect(_on_next_tile_reached)
	snake_head.got_hit.connect(collision_iframes.bind(GameConsts.COLLISION_IFRAMES))
	
	initialized.emit()

var invincibility_expired: bool = false
func _on_next_tile_reached():
	if invincible_ticks > 0:
		snake_head.right_collision_ray.set_collision_mask_value(6,false)
		snake_head.left_collision_ray.set_collision_mask_value(6,false)
		snake_head.front_collision_ray.set_collision_mask_value(6,false)
		snake_head.right_collision_ray.set_collision_mask_value(7,false)
		snake_head.left_collision_ray.set_collision_mask_value(7,false)
		snake_head.front_collision_ray.set_collision_mask_value(7,false)
		for bodypart in snake_path_bodyparts:
			bodypart.modulate.a = 0.8
		for obstacle in find_child("ObstacleElements").get_children():
			if not obstacle is Area2D:
				obstacle.modulate. a = 0.8
		invincible_ticks -= 1
		if invincible_ticks == 0:
			invincibility_expired = true
	elif invincibility_expired:
		invincibility_expired = false
		snake_head.right_collision_ray.set_collision_mask_value(6,true)
		snake_head.left_collision_ray.set_collision_mask_value(6,true)
		snake_head.front_collision_ray.set_collision_mask_value(6,true)
		snake_head.right_collision_ray.set_collision_mask_value(7,true)
		snake_head.left_collision_ray.set_collision_mask_value(7,true)
		snake_head.front_collision_ray.set_collision_mask_value(7,true)
		for bodypart in snake_path_bodyparts:
			bodypart.modulate.a = 1
		for obstacle in find_child("ObstacleElements").get_children():
			if not obstacle is Area2D:
				obstacle.modulate.a = 1
		
	

#returns an array of valid positions for fruits to spawn in
func find_free_map_tiles() -> Array[Vector2i]:
	#map_tiles contains every tile in the grid
	var map_tiles: Array[Vector2i]
	for x in range(grid_size.x):
		for y in range(grid_size.y):
				map_tiles.append(Vector2i(x,y))
	
	#creates an array containing every position of static solid elements
	var solid_element_positions = get_tree().get_nodes_in_group("Static Solid Element").map(
	func(solid_elem): return TileHelper.position_to_tile(solid_elem.position))
	
	#subtract all elements from the grid array that have solid elements
	map_tiles = map_tiles.filter(func(x): return not solid_element_positions.has(x))
	
	map_tiles.shuffle()
	return map_tiles

func update_free_map_tiles(tile: Vector2i, add_tile: bool):
	if add_tile:
		free_map_tiles.append(tile)
	else:
		print(free_map_tiles.size())
		free_map_tiles.erase(tile)
		print(free_map_tiles.size())
	

#find starting positions for snake head, body and tail
func teleport_to_starting_position():
	snake_head = snake_head_scene.instantiate()
	snake_tail = snake_tail_scene.instantiate()
	add_child(snake_head)
	add_child(snake_tail)
	for snake_body_count in len(range(4)):
		var snake_body = snake_body_scene.instantiate()
		add_child(snake_body)
		snake_path_bodyparts.append(snake_body)
	
	#place snake head
	snake_head.current_tile = (starting_position / GameConsts.TILE_SIZE)
	snake_head.position = starting_position
	
	#place body parts below snake head
	var snake_body_num = 4
	for bodypart in snake_path_bodyparts:
		bodypart.position = starting_position + Vector2(0, GameConsts.TILE_SIZE * snake_body_num) 
		snake_body_num -= 1
	
	#place snake tail as far below head ass body parts exist
	snake_tail.current_tile = snake_head.current_tile
	for i in range(len(snake_path_bodyparts)):
		snake_tail.current_tile = TileHelper.get_next_tile(snake_tail.current_tile, DIRECTION.DOWN)
	snake_tail.position = TileHelper.get_next_tile(snake_tail.current_tile, DIRECTION.DOWN) * GameConsts.TILE_SIZE

#connected to signal collision_with in map_element.gd emitted in snake_head.gd when head collides with a head element
func _on_collision_with(element: MapElement):
	#on fruit collision, grow once, delete fruit and spawn a new one
	if element is FruitElement:
		element.collected = true
		snake_tail.tiles_to_grow += 1
		SignalBus.fruit_collected.emit(element, true)
		spawn_fruit(fruit_locations)
		fruit_locations.erase(TileHelper.position_to_tile(element.position))
		element.collected_anim(snake_head.position, TileHelper.tile_to_position(snake_head.next_tile))
		
func spawn_teleporter(destination: Vector2) -> Teleporter:
	var teleporter: Teleporter = teleport_element_scene.instantiate()
	add_child(teleporter)
	teleporter.position = TileHelper.tile_to_position( TileHelper.get_next_tile(snake_head.next_tile, snake_head.current_direction))
	teleporter.rotation = snake_head.get_orientation(snake_head.current_direction, 0.0) + (PI)
	teleporter.destination_tile = TileHelper.position_to_tile(to_local(destination))
	return teleporter
	

#spawn a new fruit in a place with no solid objects, including the snake
#additional excluded tiles can be handed by forbidden_tiles
func spawn_fruit(forbidden_tiles: Array[Vector2i]):
	#instantiate new fruit
	var fruit: FruitElement = fruit_element_scene.instantiate()
	add_child(fruit)
	
	#create a copy of tha array containing all free tiles
	var currently_free_map_tiles = free_map_tiles.duplicate()
	
	#erase every tile from that array that is occupied by snake + the tile snake will now occupie (current fruit tile)
	for snake_part in get_tree().get_nodes_in_group("Snake"):
		var snakepartpos = snake_part.position
		currently_free_map_tiles.erase(TileHelper.position_to_tile(snakepartpos))
	currently_free_map_tiles.erase(snake_head.next_tile)
	
	var free_map_tiles_without_forbidden = currently_free_map_tiles
	
	for tile in forbidden_tiles:
		currently_free_map_tiles.erase(tile)
	
	if currently_free_map_tiles.size() < 5:
		fruit.position = TileHelper.tile_to_position(free_map_tiles_without_forbidden[randi() % currently_free_map_tiles.size()])
	else:
		fruit.position = TileHelper.tile_to_position(currently_free_map_tiles[randi() % currently_free_map_tiles.size()])
		
	fruit_locations.append(TileHelper.position_to_tile(fruit.position))
	
	
	

#place a new snake body where the head is, add it to the bodypart array, add the new direction to direction array
func push_snake_directions(direction :int):
	snake_path_directions.push_back(direction)

func push_snake_bodyparts(tile: Vector2i, direction: int, push_overlap_bodypart: bool):
	var newest_snake_body = SnakeBody.new_snakebody(snake_path_directions[-1], direction)
	add_child(newest_snake_body)
	newest_snake_body.position = tile * GameConsts.TILE_SIZE
	snake_path_bodyparts.push_back(newest_snake_body)
	if push_overlap_bodypart:
		newest_snake_body._on_snake_overlaps(true)
		snake_head.push_overlap_bodypart = false

#delete the bodypart and direction located at the tail from their arrays. returns the direction
func pop_snake_directions() -> int:
	return snake_path_directions.pop_front()

func pop_snake_bodyparts():
	snake_path_bodyparts.pop_front().queue_free()
	if snake_path_bodyparts.size()==0:
		get_tree().quit()
	unload_solidElement(snake_path_bodyparts[0])
	
#called for moving objects like snake tail or moving obstacles so that no collision is anticipated
func unload_solidElement(obj: Node):
	for child in obj.get_children():
		if child is SolidElement:
			child.set_collision_layer_value(6,false)

func add_upgrade_component(upgrade: int):
	match upgrade:
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_1:
			var fruit_magnet_1_component = fruit_magnet_1_component_scene.instantiate()
			snake_head.add_child(fruit_magnet_1_component)
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_2:
			var fruit_magnet_2_component = fruit_magnet_2_component_scene.instantiate()
			snake_head.add_child(fruit_magnet_2_component)
		GameConsts.UPGRADE_LIST.FRUIT_MAGNET_3:
			var fruit_magnet_3_component = fruit_magnet_3_component_scene.instantiate()
			snake_head.add_child(fruit_magnet_3_component)
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1:
			var double_fruit_1_component = double_fruit_1_component_scene.instantiate()
			add_child(double_fruit_1_component)
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2:
			var double_fruit_2_component = double_fruit_2_component_scene.instantiate()
			add_child(double_fruit_2_component)
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3:
			var double_fruit_3_component = double_fruit_3_component_scene.instantiate()
			add_child(double_fruit_3_component)
		GameConsts.UPGRADE_LIST.EDGE_WRAP_1:
			var edge_wrap_1_component = edge_wrap_1_component_scene.instantiate()
			add_child(edge_wrap_1_component)
		GameConsts.UPGRADE_LIST.CORNER_PHASING:
			var corner_phasing = corner_phasing_scene.instantiate()
			add_child(corner_phasing)
		GameConsts.UPGRADE_LIST.ANCHOR:
			var anchor_component = anchor_component_scene.instantiate()
			snake_head.add_child(anchor_component)

func apply_mapmod(mapmod: int):
	print(GameConsts.MAP_MODS.find_key(mapmod))
	match mapmod:
		GameConsts.MAP_MODS.CAFFEINATED:
			var caffeinated_component = caffeinated_component_scene.instantiate()
			add_child(caffeinated_component)
		GameConsts.MAP_MODS.TAILVIRUS:
			var tailvirus_component = tailvirus_component_scene.instantiate()
			snake_tail.add_child(tailvirus_component)
		GameConsts.MAP_MODS.EDIBLE_PAPER:
			var edible_paper_component = edible_paper_component_scene.instantiate()
			add_child(edible_paper_component)
		GameConsts.MAP_MODS.LASER:
			var laser_component = laser_component_scene.instantiate()
			add_child(laser_component)
		GameConsts.MAP_MODS.FRUIT_BODY:
			var fruit_body_component = fruit_body_component_scene.instantiate()
			add_child(fruit_body_component)
		GameConsts.MAP_MODS.TETRI_FRUIT:
			var tetri_fruit_component = tetri_fruit_component_scene.instantiate()
			add_child(tetri_fruit_component)

func _on_round_over():
	destroy_current_mapmod()

func destroy_current_mapmod():
	var current_mod = get_tree().get_first_node_in_group("MapMod")
	if current_mod == null:
		print_debug("mapmod could not be found and thus was not destroyed")
	else:
		current_mod.self_destruct()

func collision_iframes(ticks: int):
	snake_got_hit.emit()
	if invincible_ticks == 0:
		invincible_ticks = ticks
	
	

#region helper functions

func find_all_fruits() -> Array[MapElement]:
	var fruits: Array[MapElement] = []
	for node: MapElement in get_tree().get_nodes_in_group("Fruit"):
		#this excludes fruit that are only in their eat up animation
		if node.get_collision_layer_value(2):
			fruits.append(node)
	return fruits
			
#endregion

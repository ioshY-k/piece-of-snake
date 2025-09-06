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
var diet_1_component_scene = load("res://UpgradeComponents/diet_1_component.tscn")
var diet_2_component_scene = load("res://UpgradeComponents/diet_2_component.tscn")
var diet_3_component_scene = load("res://UpgradeComponents/diet_3_component.tscn")
var double_fruit_1_component_scene = load("res://UpgradeComponents/double_fruit_1_component.tscn")
var double_fruit_2_component_scene = load("res://UpgradeComponents/double_fruit_2_component.tscn")
var double_fruit_3_component_scene = load("res://UpgradeComponents/double_fruit_3_component.tscn")
var magic_flute_1_component_scene = load("res://UpgradeComponents/magic_flute_1_component.tscn")
var magic_flute_2_component_scene = load("res://UpgradeComponents/magic_flute_2_component.tscn")
var magic_flute_3_component_scene = load("res://UpgradeComponents/magic_flute_3_component.tscn")
var edge_wrap_component_scene = load("res://UpgradeComponents/edge_wrap_component.tscn")
var corner_phasing_scene = load("res://UpgradeComponents/corner_phasing_component.tscn")
var anchor_component_scene = load("res://UpgradeComponents/anchor_component.tscn")
var tail_cut_component_scene = load("res://UpgradeComponents/tail_cut_component.tscn")
var steel_helmet_component_scene = load("res://UpgradeComponents/steel_helmet_component.tscn")
var rubber_band_component_scene = load("res://UpgradeComponents/rubber_band_component.tscn")
var plant_snake_component_scene = load("res://UpgradeComponents/plant_snake_component.tscn")
var dance_component_scene = load("res://UpgradeComponents/dance_component.tscn")
var half_gone_component_scene = load("res://UpgradeComponents/half_gone_component.tscn")
var immutable_component_scene = load("res://UpgradeComponents/immutable_component.tscn")

#mapmods
var caffeinated_component_scene = load("res://MapModComponents/caffeinated_component.tscn")
var tailvirus_component_scene = load("res://MapModComponents/tail_virus_component.tscn")
var edible_paper_component_scene = load("res://MapModComponents/edible_paper_component.tscn")
var laser_component_scene = load("res://MapModComponents/laser_component.tscn")
var fruit_body_component_scene = load("res://MapModComponents/fruit_body_component.tscn")
var tetri_fruit_component_scene = load("res://MapModComponents/tetri_fruit_component.tscn")
var moving_fruit_component_scene = load("res://MapModComponents/moving_fruit_component.tscn")
var anti_magnet_component_scene = load("res://MapModComponents/anti_magnet_component.tscn")
var ghost_invasion_component_scene = load("res://MapModComponents/ghost_invasion_component.tscn")

#permanent snake parts
@onready var snake_head: SnakeHead
@onready var snake_tail: SnakeTail

#map data
@onready var obstacle_elements: Node2D = $ObstacleElements
@export var grid_size: Vector2i
@export var inbounds_grid_size: Vector2i
@export var starting_position: Vector2
var zoom_state: int = 0 #0 by default and +1 for each area size upgrade
var current_fruits: Array[FruitElement]


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
	snake_head.frame = 0 + (RunSettings.current_char * 3) #frames per snakehead
	snake_tail.frame = 0 + (RunSettings.current_char * 1) #frames per snaketail
	match RunSettings.current_char:
		GameConsts.CHAR_LIST.SALAMANDER:
			snake_head.enable_legs(GameConsts.CHAR_LIST.SALAMANDER)
			snake_tail.enable_legs(GameConsts.CHAR_LIST.SALAMANDER)
		GameConsts.CHAR_LIST.CHAMELEON:
			snake_head.enable_legs(GameConsts.CHAR_LIST.CHAMELEON)
			snake_tail.enable_legs(GameConsts.CHAR_LIST.CHAMELEON)
		_:
			snake_head.disable_legs()
			snake_tail.disable_legs()
	
	spawn_fruit([])
	
	SignalBus.round_over.connect(_on_round_over)
	SignalBus.next_tile_reached.connect(_on_next_tile_reached)
	SignalBus.got_hit.connect(collision_iframes.bind(GameConsts.COLLISION_IFRAMES))
	
	initialized.emit()

var invincibility_expired: bool = false
func _on_next_tile_reached():
	print(current_fruits.size())
	var counter = 0
	for fruit in current_fruits:
		if fruit.is_in_group("Ghost Fruit"):
			counter += 1
	print(counter , " Ghosts")
	if invincible_ticks > 0:
		snake_head.right_collision_ray.set_collision_mask_value(6,false)
		snake_head.left_collision_ray.set_collision_mask_value(6,false)
		snake_head.front_collision_ray.set_collision_mask_value(6,false)
		snake_head.right_collision_ray.set_collision_mask_value(7,false)
		snake_head.left_collision_ray.set_collision_mask_value(7,false)
		snake_head.front_collision_ray.set_collision_mask_value(7,false)
		snake_head.right_collision_ray.set_collision_mask_value(10,true)
		snake_head.left_collision_ray.set_collision_mask_value(10,true)
		snake_head.front_collision_ray.set_collision_mask_value(10,true)
		for bodypart:SnakeBody in snake_path_bodyparts:
			bodypart.modulate.a = 0.8
			bodypart.solid_element.set_collision_layer_value(10,true)
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
		snake_head.right_collision_ray.set_collision_mask_value(10,false)
		snake_head.left_collision_ray.set_collision_mask_value(10,false)
		snake_head.front_collision_ray.set_collision_mask_value(10,false)
		for bodypart in snake_path_bodyparts:
			bodypart.modulate.a = 1
			bodypart.solid_element.set_collision_layer_value(10,false)
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
		free_map_tiles.erase(tile)
	

#find starting positions for snake head, body and tail
func teleport_to_starting_position():
	snake_head = snake_head_scene.instantiate()
	snake_tail = snake_tail_scene.instantiate()
	
	add_child(snake_head)
	add_child(snake_tail)
	for snake_body_count in len(range(4)):
		var snake_body: SnakeBody = snake_body_scene.instantiate()
		snake_body.frame = 1 + (RunSettings.current_char * 9) #frames per snake
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
func _on_collision_with(element: MapElement, collect_position: Vector2):
	#on fruit collision, grow once, delete fruit and spawn a new one (if not ghost fruit)
	if element is FruitElement:
		element.collected = true
		snake_tail.tiles_to_grow += 1
		SignalBus.fruit_collected.emit(element, true)
		if not element.is_in_group("Ghost Fruit"):
			var fruit_positions: Array = current_fruits.map(
			func(fruit): return TileHelper.position_to_tile(fruit.position))
			spawn_fruit(fruit_positions)
		current_fruits.erase(element)
		element.collected_anim(collect_position, TileHelper.tile_to_position(snake_head.next_tile))
		
func spawn_teleporter(destination: Vector2) -> Teleporter:
	var teleporter: Teleporter = teleport_element_scene.instantiate()
	add_child(teleporter)
	teleporter.position = TileHelper.tile_to_position( TileHelper.get_next_tile(snake_head.next_tile, snake_head.current_direction))
	teleporter.rotation = snake_head.get_orientation(snake_head.current_direction, 0.0) + (PI)
	teleporter.destination_tile = TileHelper.position_to_tile(to_local(destination))
	return teleporter
	

func spawn_ghost_fruit(forbidden_tiles: Array[Vector2i]) -> FruitElement:
	#instantiate new ghost fruit
	var fruit: FruitElement = fruit_element_scene.instantiate()
	add_child(fruit)
	fruit.add_to_group("Ghost Fruit")
	fruit.fruit_element_sprite.frame = 1
	place_fruit(forbidden_tiles, fruit)
	SignalBus.ghost_fruit_spawned.emit(fruit)
	return fruit

func spawn_fruit(forbidden_tiles: Array):
	#instantiate new fruit
	var fruit: FruitElement = fruit_element_scene.instantiate()
	add_child(fruit)
	place_fruit(forbidden_tiles, fruit)
	SignalBus.fruit_spawned.emit(fruit)

var temporary_obstacles:Array = []
#place a new fruit in a place with no solid objects, including the snake
#additional excluded tiles can be handed by forbidden_tiles
func place_fruit(forbidden_tiles: Array, fruit: FruitElement):
	#create a copy of tha array containing all free tiles
	var currently_free_map_tiles: Array = free_map_tiles.duplicate()
	currently_free_map_tiles = currently_free_map_tiles.filter(func(e): return not temporary_obstacles.has(e))
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
		
	current_fruits.append(fruit)
	
	

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
		GameConsts.UPGRADE_LIST.DIET_1:
			var diet_1_component = diet_1_component_scene.instantiate()
			snake_tail.add_child(diet_1_component)
		GameConsts.UPGRADE_LIST.DIET_2:
			var diet_2_component = diet_2_component_scene.instantiate()
			snake_tail.add_child(diet_2_component)
		GameConsts.UPGRADE_LIST.DIET_3:
			var diet_3_component = diet_3_component_scene.instantiate()
			snake_tail.add_child(diet_3_component)
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_1:
			var double_fruit_1_component = double_fruit_1_component_scene.instantiate()
			add_child(double_fruit_1_component)
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_2:
			var double_fruit_2_component = double_fruit_2_component_scene.instantiate()
			add_child(double_fruit_2_component)
		GameConsts.UPGRADE_LIST.DOUBLE_FRUIT_3:
			var double_fruit_3_component = double_fruit_3_component_scene.instantiate()
			add_child(double_fruit_3_component)
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_1:
			var magic_flute_1_component = magic_flute_1_component_scene.instantiate()
			add_child(magic_flute_1_component)
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_2:
			var magic_flute_2_component = magic_flute_2_component_scene.instantiate()
			add_child(magic_flute_2_component)
		GameConsts.UPGRADE_LIST.MAGIC_FLUTE_3:
			var magic_flute_3_component = magic_flute_3_component_scene.instantiate()
			add_child(magic_flute_3_component)
		GameConsts.UPGRADE_LIST.EDGE_WRAP:
			var edge_wrap_component = edge_wrap_component_scene.instantiate()
			add_child(edge_wrap_component)
		GameConsts.UPGRADE_LIST.DANCE:
			var dance_component = dance_component_scene.instantiate()
			add_child(dance_component)
		GameConsts.UPGRADE_LIST.TAIL_CUT:
			var tail_cut_component = tail_cut_component_scene.instantiate()
			add_child(tail_cut_component)
		GameConsts.UPGRADE_LIST.STEEL_HELMET:
			var steel_helmet_component = steel_helmet_component_scene.instantiate()
			snake_head.add_child(steel_helmet_component)
		GameConsts.UPGRADE_LIST.CORNER_PHASING:
			var corner_phasing = corner_phasing_scene.instantiate()
			add_child(corner_phasing)
		GameConsts.UPGRADE_LIST.ANCHOR:
			var anchor_component = anchor_component_scene.instantiate()
			snake_head.add_child(anchor_component)
		GameConsts.UPGRADE_LIST.RUBBER_BAND:
			var rubber_band_component = rubber_band_component_scene.instantiate()
			add_child(rubber_band_component)
		GameConsts.UPGRADE_LIST.PLANT_SNAKE:
			var plant_snake_component = plant_snake_component_scene.instantiate()
			snake_tail.add_child(plant_snake_component)
		GameConsts.UPGRADE_LIST.HALF_GONE:
			var half_gone_component = half_gone_component_scene.instantiate()
			add_child(half_gone_component)
		GameConsts.UPGRADE_LIST.IMMUTABLE:
			var immutable_component = immutable_component_scene.instantiate()
			add_child(immutable_component)

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
		GameConsts.MAP_MODS.MOVING_FRUIT:
			var moving_fruit_component = moving_fruit_component_scene.instantiate()
			add_child(moving_fruit_component)
		GameConsts.MAP_MODS.ANTI_MAGNET:
			var anti_magnet_component = anti_magnet_component_scene.instantiate()
			add_child(anti_magnet_component)
		GameConsts.MAP_MODS.GHOST_INVASION:
			var ghost_invasion_component = ghost_invasion_component_scene.instantiate()
			add_child(ghost_invasion_component)

func _on_round_over():
	cleanup_ghost_fruits()
	destroy_current_mapmod()

func cleanup_ghost_fruits():
	for fruit in current_fruits.duplicate():
		if fruit.is_in_group("Ghost Fruit"):
			current_fruits.erase(fruit)
			fruit.queue_free()

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

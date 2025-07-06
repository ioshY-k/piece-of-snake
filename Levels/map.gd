class_name Map extends Sprite2D

#temporary instatiated map elements
var snake_body_scene = load("res://Snake/Body/snake_body.tscn")
var snake_head_scene = preload("res://Snake/Head/snake_head.tscn")
var snake_tail_scene = preload("res://Snake/Tail/snake_tail.tscn")
var fruit_element_scene = load("res://MapElements/FruitElements/fruit_element.tscn")

var fruit_magnet_1_component_scene = load("res://UpgradeComponents/fruit_magnet_1_component.tscn")
var fruit_magnet_2_component_scene = load("res://UpgradeComponents/fruit_magnet_2_component.tscn")
var fruit_magnet_3_component_scene = load("res://UpgradeComponents/fruit_magnet_3_component.tscn")
var double_fruit_1_component_scene = load("res://UpgradeComponents/double_fruit_1_component.tscn")
var double_fruit_2_component_scene = load("res://UpgradeComponents/double_fruit_2_component.tscn")
var double_fruit_3_component_scene = load("res://UpgradeComponents/double_fruit_3_component.tscn")

#permanent snake parts
@onready var snake_head: SnakeHead
@onready var snake_tail: SnakeTail

#map data
@export var grid_size: Vector2i
@export var starting_position: Vector2
var fruit_locations: Array[Vector2i]


#arrays containing Snake data for the tail to follow
enum DIRECTION {UP,RIGHT,DOWN,LEFT, STOP}
var snake_path_directions: Array[int] = [DIRECTION.UP, DIRECTION.UP, DIRECTION.UP, DIRECTION.UP]
var snake_path_bodyparts: Array[SnakeBody]

#array containing constantly free tiles for fruits to spawn in
var free_map_tiles: Array[Vector2i]

var invincible_ticks = 0

#on fruit collection
signal fruit_collected
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
	
	snake_head.next_tile_reached.connect(_on_next_tile_reached)
	snake_head.got_hit.connect(collision_iframes.bind(GameConsts.COLLISION_IFRAMES))
	
	initialized.emit()


func _on_next_tile_reached():
	if invincible_ticks > 0:
		for bodypart in snake_path_bodyparts:
			bodypart.find_child("SolidElement").set_collision_layer_value(1,false)
		invincible_ticks -= 1
	else:
		for bodypart in snake_path_bodyparts:
			bodypart.find_child("SolidElement").set_collision_layer_value(1,true)
		
	

#returns an array of valid positions for fruits to spawn in
func find_free_map_tiles() -> Array[Vector2i]:
	#map_tiles contains every tile in the grid
	var map_tiles: Array[Vector2i]
	for x in len(range(grid_size.x)):
		for y in len(range(grid_size.y)):
				map_tiles.append(Vector2i(x,y))
	
	#creates an array containing every position of static solid elements
	var solid_element_positions = get_tree().get_nodes_in_group("Static Solid Element").map(
	func(solid_elem): return position_to_tile(solid_elem.position))
	
	#subtract all elements from the grid array that have solid elements
	map_tiles = map_tiles.filter(func(x): return not solid_element_positions.has(x))
	
	map_tiles.shuffle()
	return map_tiles

func update_free_map_tiles(tile: Vector2i):
	free_map_tiles.append(tile)
	

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
		snake_tail.current_tile = get_next_tile(snake_tail.current_tile, DIRECTION.DOWN)
	snake_tail.position = get_next_tile(snake_tail.current_tile, DIRECTION.DOWN) * GameConsts.TILE_SIZE

#connected to signal collision_with in map_element.gd emitted in snake_head.gd when head collides with a head element
func _on_collision_with(element: MapElement):
	#on fruit collision, grow once, delete fruit and spawn a new one
	if element is FruitElement:
		snake_tail.tiles_to_grow += 1
		fruit_collected.emit(element)
		spawn_fruit(fruit_locations)
		fruit_locations.erase(GameConsts.position_to_tile(element.position))
		element.collected_anim(snake_head.position, GameConsts.tile_to_position(snake_head.next_tile))
		


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
		currently_free_map_tiles.erase(position_to_tile(snakepartpos))
	currently_free_map_tiles.erase(snake_head.next_tile)
	
	var free_map_tiles_without_forbidden = currently_free_map_tiles
	
	for tile in forbidden_tiles:
		currently_free_map_tiles.erase(position_to_tile(tile))
	
	if currently_free_map_tiles.size() < 5:
		fruit.position = tile_to_position(free_map_tiles_without_forbidden[randi() % currently_free_map_tiles.size()])
	else:
		fruit.position = tile_to_position(currently_free_map_tiles[randi() % currently_free_map_tiles.size()])
		
	fruit_locations.append(GameConsts.position_to_tile(fruit.position))
	
	
	

#place a new snake body where the head is, add it to the bodypart array, add the new direction to direction array
func push_snake_directions(direction :int):
	snake_path_directions.push_back(direction)

func push_snake_bodyparts(tile: Vector2i, direction: int):
	var newest_snake_body = SnakeBody.new_snakebody(snake_path_directions[-1], direction)
	add_child(newest_snake_body)
	newest_snake_body.position = tile * GameConsts.TILE_SIZE
	snake_path_bodyparts.push_back(newest_snake_body)

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
		if "SolidElement" in child.name:
			child.set_collision_layer_value(1,false)

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
	
func collision_iframes(ticks: int):
	snake_got_hit.emit()
	if invincible_ticks == 0:
		invincible_ticks = ticks
	
	

#region helper functions
#converts a tile vector to it's actual position
func tile_to_position(tile: Vector2i) -> Vector2:
	return tile * GameConsts.TILE_SIZE

#converts a position to its tile vector
func position_to_tile(pos: Vector2) -> Vector2i:
	var tileval = round(pos / GameConsts.TILE_SIZE)
	return tileval
		
#calculates the tile vector to the left/right/top/bottom of a fiven field
func get_next_tile(current_tile: Vector2i, direction) -> Vector2i:
	match direction:
		DIRECTION.UP:
			return Vector2i(current_tile.x, current_tile.y-1)
		DIRECTION.RIGHT:
			return Vector2i(current_tile.x+1, current_tile.y)
		DIRECTION.DOWN:
			return Vector2i(current_tile.x, current_tile.y+1)
		DIRECTION.LEFT:
			return Vector2i(current_tile.x-1, current_tile.y)
		_:
			return Vector2i.ZERO

func find_all_fruits() -> Array[MapElement]:
	var fruits: Array[MapElement] = []
	for node: MapElement in get_tree().get_nodes_in_group("Fruit"):
		#this excludes fruit that are only in their eat up animation
		if node.get_collision_layer_value(2):
			fruits.append(node)
	return fruits
			
#endregion

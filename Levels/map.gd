class_name Map extends Sprite2D

#temporary instatiated map elements
var snake_body_scene = load("res://Snake/Body/snake_body.tscn")
var fruit_element_scene = load("res://MapElements/FruitElements/fruit_element.tscn")

#permanent snake parts
@onready var snake_head: SnakeHead = $SnakeHead
@onready var snake_tail: SnakeTail = $SnakeTail

#map data
@export var grid_size: Vector2i
@export var starting_position: Vector2


#arrays containing Snake data for the tail to follow
enum DIRECTION {UP,RIGHT,DOWN,LEFT}
var snake_path_directions: Array[int] = [DIRECTION.UP, DIRECTION.UP, DIRECTION.UP]
var snake_path_bodyparts: Array[SnakeBody]

#array containing constantly free tiles for fruits to spawn in
var free_map_tiles: Array[Vector2i]

#on fruit collection
signal fruit_collected
#making sure map initializes before snake
signal initialized

func _ready() -> void:
	#change the seed for randomness
	randomize()
	
	#set up attributes
	starting_position = starting_position * GameConsts.TILE_SIZE
	snake_path_bodyparts = [$SnakeBody4, $SnakeBody3, $SnakeBody2, $SnakeBody]
	free_map_tiles = find_free_map_tiles()
	
	#place fruit and player
	teleport_to_starting_position()
	spawn_fruit()
	
	print(free_map_tiles.size())
	initialized.emit()


#returns an array of valid positions for fruits to spawn in
func find_free_map_tiles() -> Array[Vector2i]:
	#map_tiles contains every tile in the grid
	var map_tiles: Array[Vector2i]
	for x in len(range(grid_size.x)):
		for y in len(range(grid_size.y)):
				map_tiles.append(Vector2i(x,y))
	
	#creates an array conaining every position of static solid elements
	var solid_element_positions = get_tree().get_nodes_in_group("Static Solid Element").map(
	func(solid_elem): return position_to_tile(solid_elem.position))
	
	#subtract all elements from the grid array that have solid elements
	map_tiles = map_tiles.filter(func(x): return not solid_element_positions.has(x))
	
	map_tiles.shuffle()
	return map_tiles


#find starting positions for snake head, body and tail
func teleport_to_starting_position():
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
		fruit_collected.emit()
		element.queue_free()
		spawn_fruit()


#spawn a new fruit in a place with no solid objects, including the snake
func spawn_fruit():
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
	#different spawn AI whe fruit count below threshhold: fruit spawn one tile away from player
	if(currently_free_map_tiles.size() <= 25):
		if currently_free_map_tiles.has(Vector2i(snake_head.next_tile.x, snake_head.next_tile.y-1)):
			fruit.position = tile_to_position(Vector2i(snake_head.next_tile.x, snake_head.next_tile.y-1))
		elif currently_free_map_tiles.has(Vector2i(snake_head.next_tile.x, snake_head.next_tile.y+1)):
			fruit.position = tile_to_position(Vector2i(snake_head.next_tile.x, snake_head.next_tile.y+1))
		elif currently_free_map_tiles.has(Vector2i(snake_head.next_tile.x+1, snake_head.next_tile.y)):
			fruit.position = tile_to_position(Vector2i(snake_head.next_tile.x+1, snake_head.next_tile.y))
		elif currently_free_map_tiles.has(Vector2i(snake_head.next_tile.x-1, snake_head.next_tile.y)):
			fruit.position = tile_to_position(Vector2i(snake_head.next_tile.x-1, snake_head.next_tile.y))
		elif currently_free_map_tiles.size() == 0:
			fruit.position = tile_to_position(Vector2i(6,8))
		else:
			fruit.position = tile_to_position(currently_free_map_tiles[randi() % currently_free_map_tiles.size()])
	#otherwise the dead end gets erased too and a random position is determined
	else:
		fruit.position = tile_to_position(currently_free_map_tiles[randi() % currently_free_map_tiles.size()])


#place a new snake body where the head is, add it to the bodypart array, add the new direction to direction array
func push_snake_directions(direction :int):
	snake_path_directions.push_back(direction)

func push_snake_bodyparts(tile: Vector2i, direction: int):
	var newest_snake_body: SnakeBody = snake_body_scene.instantiate()
	add_child(newest_snake_body)
	newest_snake_body.position = tile * GameConsts.TILE_SIZE
	newest_snake_body.find_correct_rotation(snake_path_directions[-1], direction)
	snake_path_bodyparts.push_back(newest_snake_body)

#delete the bodypart and direction located at the tail from their arrays. returns the direction
func pop_snake_directions() -> int:
	return snake_path_directions.pop_front()

func pop_snake_bodyparts():
	snake_path_bodyparts.pop_front().queue_free()
	if snake_path_bodyparts.size()==0:
		get_tree().quit()
	take_away_solidElement(snake_path_bodyparts[0])
	

func take_away_solidElement(obj: Node):
	for child in obj.get_children():
		if "SolidElement" in child.name:
			child.queue_free()


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
#endregion

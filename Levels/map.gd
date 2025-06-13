class_name Map extends Sprite2D

var snake_body_scene = load("res://Snake/Body/snake_body.tscn")
var fruit_element_scene = load("res://MapElements/FruitElements/fruit_element.tscn")
@onready var snake_head: Snake = $SnakeHead
@onready var snake_tail: Tail = $SnakeTail


@export var grid_size: Vector2i
@export var starting_position: Vector2
const TILE_SIZE = 80


enum DIRECTION {UP,RIGHT,LEFT,DOWN}

var snake_path_directions: Array[int] = [DIRECTION.UP, DIRECTION.UP, DIRECTION.UP]
var snake_path_bodyparts: Array[SnakeBody]
var free_map_tiles: Array[Vector2i]

signal initialized
func _ready() -> void:
	randomize()
	starting_position = starting_position * TILE_SIZE
	snake_path_bodyparts = [$SnakeBody4, $SnakeBody3, $SnakeBody2, $SnakeBody]
	
	free_map_tiles = find_free_map_tiles()
	spawn_fruit()
	teleport_to_starting_position()
	initialized.emit()

func find_free_map_tiles() -> Array[Vector2i]:
	var map_tiles: Array[Vector2i]
	for x in len(range(grid_size.x)):
		for y in len(range(grid_size.y)):
				map_tiles.append(Vector2i(x,y))
	var solid_element_positions = get_tree().get_nodes_in_group("Static Solid Element").map(
	func(solid_elem): return position_to_tile(solid_elem.position))
	
	#subtract all elements from the map tile array, that have solid elements
	map_tiles = map_tiles.filter(func(x): return not solid_element_positions.has(x))
	
	map_tiles.shuffle()
	return map_tiles

func teleport_to_starting_position():
	snake_head.current_tile = (starting_position / TILE_SIZE)
	snake_head.position = starting_position
	
	var snake_body_num = 4
	for bodypart in snake_path_bodyparts:
		bodypart.position = starting_position + Vector2(0, TILE_SIZE * snake_body_num) 
		snake_body_num -= 1
	
	
	snake_tail.current_tile = (starting_position / TILE_SIZE)
	for i in range(len(snake_path_bodyparts)):
		snake_tail.current_tile = get_next_tile(snake_tail.current_tile, DIRECTION.DOWN)
	snake_tail.position = get_next_tile(snake_tail.current_tile, DIRECTION.DOWN) * TILE_SIZE
	
	

func spawn_fruit():
	var fruit: FruitElement = fruit_element_scene.instantiate()
	add_child(fruit)
	var currently_free_map_tiles = free_map_tiles.duplicate()
	
	
	for snake_part in get_tree().get_nodes_in_group("Snake"):
		currently_free_map_tiles.erase(position_to_tile(snake_part.position))
	currently_free_map_tiles.erase(position_to_tile(snake_head.next_tile))
	currently_free_map_tiles.erase(position_to_tile(snake_head.current_tile))
	print(currently_free_map_tiles.size())
	if(currently_free_map_tiles.size() <= 30):
		if currently_free_map_tiles.has(Vector2i(snake_head.next_tile.x, snake_head.next_tile.y-1)):
			fruit.position = tile_to_position(Vector2i(snake_head.next_tile.x, snake_head.next_tile.y-1))
		if currently_free_map_tiles.has(Vector2i(snake_head.next_tile.x, snake_head.next_tile.y+1)):
			fruit.position = tile_to_position(Vector2i(snake_head.next_tile.x, snake_head.next_tile.y+1))
		if currently_free_map_tiles.has(Vector2i(snake_head.next_tile.x+1, snake_head.next_tile.y)):
			fruit.position = tile_to_position(Vector2i(snake_head.next_tile.x+1, snake_head.next_tile.y))
		if currently_free_map_tiles.has(Vector2i(snake_head.next_tile.x-1, snake_head.next_tile.y)):
			fruit.position = tile_to_position(Vector2i(snake_head.next_tile.x-1, snake_head.next_tile.y))
	else:
		currently_free_map_tiles.erase(Vector2i(8,8))
		fruit.position = tile_to_position(currently_free_map_tiles[randi() % currently_free_map_tiles.size()])

func tile_to_position(tile: Vector2i) -> Vector2:
	return tile * TILE_SIZE

func position_to_tile(pos: Vector2) -> Vector2i:
	return round(pos / TILE_SIZE)
		

func get_next_tile(current_tile: Vector2i, direction) -> Vector2i:
	match direction:
		DIRECTION.UP:
			if current_tile.y == 0:
				return current_tile
			else:
				return Vector2i(current_tile.x, current_tile.y-1)	
		DIRECTION.RIGHT:
			if current_tile.x == grid_size.x-1:
				return current_tile
			else:
				return Vector2i(current_tile.x+1, current_tile.y)	
		DIRECTION.DOWN:
			if current_tile.y == grid_size.y-1:
				return current_tile
			else:
				return Vector2i(current_tile.x, current_tile.y+1)	
		DIRECTION.LEFT:
			if current_tile.x == 0:
				return current_tile
			else:
				return Vector2i(current_tile.x-1, current_tile.y)
		_:
			return Vector2i.ZERO


var newest_snake_body: SnakeBody
func place_snake_body(tile: Vector2i):
	newest_snake_body = snake_body_scene.instantiate()
	add_child(newest_snake_body)
	newest_snake_body.position = tile * TILE_SIZE

func delete_snake_body():
	var bodypart: SnakeBody = snake_path_bodyparts.pop_front()
	bodypart.queue_free()
	
func push_snake_path_directions(direction: int):
	snake_path_directions.push_back(direction)

func push_snake_path_bodyparts():
	snake_path_bodyparts.push_back(newest_snake_body)
	
func pop_snake_path_directions() -> int:
	return snake_path_directions.pop_front()

func _on_collision_with(element: MapElement):
	if element is FruitElement:
		snake_tail.tiles_to_grow += 1
		element.queue_free()
		spawn_fruit()
	

class_name Map extends Sprite2D

var snake_body_scene = load("res://Snake/Body/snake_body.tscn")
@onready var snake_head: Snake = $SnakeHead
@onready var snake_tail: Tail = $SnakeTail


@export var grid_size: Vector2i
@export var starting_position: Vector2
const TILE_SIZE = 80


enum DIRECTION {UP,RIGHT,LEFT,DOWN}

var snake_path_directions: Array[int] = [DIRECTION.UP, DIRECTION.UP, DIRECTION.UP]
var snake_path_bodyparts: Array[SnakeBody]

signal initialized
func _ready() -> void:
	starting_position = starting_position * TILE_SIZE
	snake_path_bodyparts = [$SnakeBody4, $SnakeBody3, $SnakeBody2, $SnakeBody]
	initialized.emit()


func teleport_to_starting_position():
	snake_head.current_tile = (starting_position / TILE_SIZE)
	snake_head.position = starting_position
	
	snake_tail.current_tile = (starting_position / TILE_SIZE)
	for i in range(len(snake_path_bodyparts)+1):
		snake_tail.current_tile = get_next_tile(snake_tail.current_tile, DIRECTION.DOWN)
	snake_tail.position = get_next_tile(snake_tail.current_tile, DIRECTION.DOWN) * TILE_SIZE
	

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

	

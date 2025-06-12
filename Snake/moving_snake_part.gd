class_name MovingSnakePart extends Sprite2D


var current_tile: Vector2i
var next_tile: Vector2i
enum DIRECTION {UP,RIGHT,LEFT,DOWN}
var current_direction

signal next_tile_reached

@onready var map: Map = get_parent()

func _ready() -> void:
	print("ready head")
	await map.initialized
	
	next_tile_reached.connect(_on_next_tile_reached.bind())
	
	map.teleport_to_starting_position()
	current_direction = DIRECTION.UP
	next_tile = current_tile
	
	next_tile_reached.emit()

func _process(delta: float) -> void:
	if position == map.tile_to_position(next_tile):
		next_tile_reached.emit()

func get_orientation(direction: int, current_rotation: float):
	match direction:
		DIRECTION.UP:
			return 0
		DIRECTION.RIGHT:
			if current_rotation < -3 * PI/4:
				rotation = PI
			return PI/2
		DIRECTION.DOWN:
			if current_rotation < (-1/4 * PI) and current_rotation < (-3/4 * PI):
				return -PI
			return PI
		DIRECTION.LEFT:
			if current_rotation > 3 * PI/4:
				rotation = -PI
			return -PI/2

func _on_next_tile_reached():
	print_debug("The Signal next_tile_reached was not connected to an existing SnakeHead or SnakeTail")
	

extends Sprite2D

enum DIRECTION {UP,RIGHT,DOWN,LEFT}
@onready var map: Map = $".."
var light_target: Vector2 = Vector2(1,1)
var snake_inside = false

@export var top_border : int
@export var right_border : int
@export var bottom_border : int
@export var left_border : int
@export var default_light_field: Vector2i


@export var switch_x : bool
var x_switcher = 1
@export var switch_y : bool
var y_switcher = 1

func _process(delta: float) -> void:
	scale = scale.lerp(light_target, 0.02)

func _ready() -> void:
	SignalBus.next_tile_reached.connect(move_light)
	if switch_x:
		x_switcher = -1
	if switch_y:
		y_switcher = -1

func move_light():
	var snake_tile = map.snake_head.current_tile
	if snake_tile.x > left_border and\
	snake_tile.x < right_border and\
	snake_tile.y > top_border and\
	snake_tile.y < bottom_border:
		if not snake_inside:
			while snake_tile.x != default_light_field.x:
				if snake_tile.x < default_light_field.x:
					light_target.x += 0.2 * x_switcher
					snake_tile.x += 1
				if snake_tile.x > default_light_field.x:
					light_target.x -= 0.2 * x_switcher
					snake_tile.x -= 1
			while snake_tile.y != default_light_field.y:
				if snake_tile.y < default_light_field.y:
					light_target.y -= 0.2 * y_switcher
					snake_tile.y += 1
				if snake_tile.y > default_light_field.y:
					light_target.y += 0.2 * y_switcher
					snake_tile.y -= 1
			snake_inside = true
		if map.snake_head.moves:
			match map.snake_head.current_direction:
				DIRECTION.UP:
					light_target.y -= 0.2 * y_switcher
				DIRECTION.RIGHT:
					light_target.x -= 0.2 * x_switcher
				DIRECTION.DOWN:
					light_target.y += 0.2 * y_switcher
				DIRECTION.LEFT:
					light_target.x += 0.2 * x_switcher
	else:
		light_target = Vector2(1,1)
		snake_inside = false
	

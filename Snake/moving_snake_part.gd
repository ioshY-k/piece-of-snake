class_name MovingSnakePart extends AnimatedSprite2D


var current_tile: Vector2i
var next_tile: Vector2i
enum DIRECTION {UP,RIGHT,DOWN,LEFT,STOP}
var current_direction

var snake_speed: float = GameConsts.NORMAL_SPEED


@onready var map: Map = get_parent()

func _ready() -> void:
	await map.initialized
	
	
	
	current_direction = DIRECTION.UP
	next_tile = current_tile
	
	SignalBus.stop_moving.connect(_on_stop_moving)
	SignalBus.continue_moving.connect(_on_continue_moving)
	
	get_moving_tween(true)
	get_turning_tween(current_direction)
	
	
func decide_speed_boost():
	if Input.is_action_pressed("speed_boost"):
		snake_speed = GameConsts.SPEED_BOOST_SPEED
	else:
		snake_speed = GameConsts.NORMAL_SPEED


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

var moving_tween: Tween
func get_moving_tween(moves: bool) -> Tween:
	var tile_to_move_to
	if moves:
		tile_to_move_to = next_tile
	else:
		tile_to_move_to = current_tile
	moving_tween = create_tween()
	moving_tween.tween_property(self, "position", map.tile_to_position(tile_to_move_to), snake_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	moving_tween.finished.connect(_on_next_tile_reached)
	return moving_tween
	
func get_turning_tween(direction: int) -> Tween:
	var turning_tween: Tween = create_tween()
	turning_tween.tween_property(self, "rotation", get_orientation(direction, rotation), 0.2).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	return turning_tween

#Should never be reached since function is overwritten in Children
func _on_next_tile_reached():
	print_debug("The Signal next_tile_reached was not connected to an existing SnakeHead or SnakeTail")
func _on_stop_moving():
	print_debug("The Signal stop_moving was not connected to an existing SnakeHead or SnakeTail")
func _on_continue_moving():
	print_debug("The Signal continue_moving was not connected to an existing SnakeHead or SnakeTail")

class_name MovingSnakePart extends Sprite2D

var moving_tween: Tween
var turning_tween: Tween

var current_tile: Vector2i
var next_tile: Vector2i
enum DIRECTION {UP,RIGHT,LEFT,DOWN}
var current_direction


@onready var map: Map = get_parent()

func _ready() -> void:
	await map.initialized
	
	current_direction = DIRECTION.UP
	next_tile = current_tile
	
	
	moving_tween = get_moving_tween()
	turning_tween = get_turning_tween()
	


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

func get_moving_tween() -> Tween:
	var moving_tween: Tween = create_tween()
	moving_tween.tween_property(self, "position", map.tile_to_position(next_tile), 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	moving_tween.finished.connect(_on_next_tile_reached)
	return moving_tween
	
func get_turning_tween() -> Tween:
	var turning_tween: Tween = create_tween()
	turning_tween.tween_property(self, "rotation", get_orientation(current_direction, rotation), 0.4).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	return turning_tween

#Should never be reached since function is overwritten in Children
func _on_next_tile_reached():
	print_debug("The Signal next_tile_reached was not connected to an existing SnakeHead or SnakeTail")
	

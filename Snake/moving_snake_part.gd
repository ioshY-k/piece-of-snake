class_name MovingSnakePart extends AnimatedSprite2D


var current_tile: Vector2i
var next_tile: Vector2i
enum DIRECTION {UP,RIGHT,DOWN,LEFT}
var current_direction

var current_snake_speed: float = GameConsts.NORMAL_SPEED
var base_snake_speed: float = GameConsts.NORMAL_SPEED

@onready var legs = [	$LeftLeg1,$LeftLeg1/LeftLeg2,$LeftLeg1/LeftLeg2/LeftLeg3,
						$RightLeg1,$RightLeg1/RightLeg2,$RightLeg1/RightLeg2/RightLeg3]
@onready var leg_animation_player: AnimationPlayer = $LegAnimationPlayer
@onready var map: Map = get_parent()

func _ready() -> void:
	await map.initialized
	
	
	
	current_direction = DIRECTION.UP
	next_tile = current_tile
	
	SignalBus.stop_moving.connect(_on_stop_moving)
	SignalBus.continue_moving.connect(_on_continue_moving)
	
	get_moving_tween(true)
	get_turning_tween(current_direction)


func get_orientation(direction: int, current_rotation: float) -> float:
	match direction:
		DIRECTION.UP:
			if abs(current_rotation-360) < abs(current_rotation-0):
				return 360
			else:
				return 0
		DIRECTION.RIGHT:
			if current_rotation == 360:
				rotation_degrees = 0
			return 90
		DIRECTION.DOWN:
			return 180
		DIRECTION.LEFT:
			if current_rotation == 0:
				rotation_degrees = 360
			return 270
		_:
			return 0

var moving_tween: Tween
func get_moving_tween(moves: bool) -> Tween:
	var tile_to_move_to
	if moves:
		tile_to_move_to = next_tile
	else:
		tile_to_move_to = current_tile
	leg_animation_player.seek(0.0, true)
	moving_tween = create_tween().set_parallel()
	moving_tween.tween_property(self, "position", TileHelper.tile_to_position(tile_to_move_to), current_snake_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if check_moves():
		moving_tween.tween_method(_set_animation_progress, 0.0, leg_animation_player.current_animation_length, current_snake_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	moving_tween.finished.connect(_on_next_tile_reached)
	return moving_tween
	
func get_turning_tween(direction: int) -> Tween:
	var turning_tween: Tween = create_tween()
	if self is SnakeTail:
		turning_tween.tween_property(self, "modulate", modulate, current_snake_speed/4.4)#just an improv timer
	
	var orientation = get_orientation(direction, rotation_degrees)
	turning_tween.tween_property(self, "rotation_degrees", orientation, current_snake_speed/1.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	return turning_tween


func _set_animation_progress(time: float):
	leg_animation_player.seek(time, true)

func enable_legs(char_id):
	$LeftLeg1.show()
	$RightLeg1.show()
	match char_id:
		GameConsts.CHAR_LIST.SALAMANDER:
			for leg in legs:
				leg.frame = 0
		GameConsts.CHAR_LIST.CHAMELEON:
			for leg in legs:
				leg.frame = 1

func disable_legs():
	$LeftLeg1.hide()
	$RightLeg1.hide()
	
#Should never be reached since function is overwritten in Children
func _on_next_tile_reached():
	print_debug("The Signal next_tile_reached was not connected to an existing SnakeHead or SnakeTail")
func _on_stop_moving():
	print_debug("The Signal stop_moving was not connected to an existing SnakeHead or SnakeTail")
func _on_continue_moving(current_direction):
	print_debug("The Signal continue_moving was not connected to an existing SnakeHead or SnakeTail")
func check_moves():
	print("The Method check_moves was not connected to an existing SnakeHead or SnakeTail")

extends ActiveItemBase

signal item_deactivated
var button_held: bool = false

var level: LevelManager
@onready var grow_back_count_down: Timer = $GrowBackCountDown
var tiles_to_grow_back = 0

func _ready() -> void:
	super._ready()
	active_item_slot = get_parent()
	level = active_item_slot.get_parent()
	show_behind_parent = true
	item_deactivated.connect(_on_item_deactivated)
	item_activated.connect(active_item_slot._on_item_activated.bind())
	SignalBus.pre_next_tile_reached.connect(_on_next_tile_reached)
	grow_back_count_down.timeout.connect(_grow_back)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(active_item_button) and uses > 0 and not shop_phase:
		button_held = true
		level.current_map.snake_tail.snek_shrinking = true
		level.current_map.snake_head.current_snake_speed = GameConsts.SPEED_BOOST_SPEED
		level.current_map.snake_tail.current_snake_speed = GameConsts.SPEED_BOOST_SPEED
		#uses-1 is the light index for the itembag to go out
		item_activated.emit(uses-1)
	if Input.is_action_just_released(active_item_button) and button_held == true:
		button_held = false
		level.current_map.snake_tail.snek_shrinking = false
		level.current_map.snake_head.current_snake_speed = GameConsts.NORMAL_SPEED
		level.current_map.snake_tail.current_snake_speed = GameConsts.NORMAL_SPEED
		item_deactivated.emit()
		uses -= 1
		SignalBus.continue_moving.emit(active_item_slot.get_parent().current_map.snake_head.current_direction)

func _on_next_tile_reached():
	if button_held:
		if level.current_map.snake_path_bodyparts.size() > 1:
			SignalBus.stop_moving.emit(true)
			tiles_to_grow_back += 1
		else:
			grow_back_count_down.start()
			level.current_map.snake_head.current_snake_speed = GameConsts.NORMAL_SPEED
			level.current_map.snake_tail.current_snake_speed = GameConsts.NORMAL_SPEED

func _on_item_deactivated():
	active_item_slot.get_parent().snake_head.moves = true
	grow_back_count_down.start()

func _grow_back():
	level.current_map.snake_tail.tiles_to_grow += tiles_to_grow_back
	while tiles_to_grow_back > 0:
		SignalBus.tail_grows.emit()
		tiles_to_grow_back -= 1

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()

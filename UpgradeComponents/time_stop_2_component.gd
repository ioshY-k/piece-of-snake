extends ActiveItemBase

signal item_deactivated
var button_held: bool = false
var level:LevelManager

func _ready() -> void:
	super._ready()
	active_item_slot = get_parent()
	level = active_item_slot.get_parent()
	show_behind_parent = true
	item_deactivated.connect(_on_item_deactivated)
	item_activated.connect(active_item_slot._on_item_activated.bind())
	SignalBus.pre_next_tile_reached.connect(_on_next_tile_reached)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(active_item_button) and uses > 0 and not shop_phase:
		button_held = true
		item_activated.emit(uses-1)
	if Input.is_action_just_released(active_item_button) and button_held == true:
		button_held = false
		item_deactivated.emit()
		#uses-1 is the light index for the itembag to go out
		uses -= 1
		SignalBus.continue_moving.emit(active_item_slot.get_parent().current_map.snake_head.current_direction)

const MAX_REVERSE_STEPS = 7
var reverse_counter = MAX_REVERSE_STEPS
func _on_next_tile_reached():
	if button_held:
		SignalBus.stop_moving.emit(false)
		if (Input.is_action_pressed("move_up") or\
		Input.is_action_pressed("move_right") or\
		Input.is_action_pressed("move_down") or\
		Input.is_action_pressed("move_left")) and\
		level.current_map.snake_path_bodyparts.size() > 1 and reverse_counter > 0:
			level.current_map.snake_head.current_tile = TileHelper.position_to_tile(level.current_map.snake_path_bodyparts[-1].position)
			var newest_bodypart = level.current_map.snake_path_bodyparts.pop_back()
			newest_bodypart.queue_free()
			level.current_map.snake_path_directions.pop_back()
			level.current_map.snake_tail.tiles_to_grow += 1
			reverse_counter -= 1
			
func _on_item_deactivated():
	active_item_slot.get_parent().snake_head.moves = true
	reverse_counter = MAX_REVERSE_STEPS

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()

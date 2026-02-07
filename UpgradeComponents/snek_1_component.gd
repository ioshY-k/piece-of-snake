extends ActiveItemBase

signal item_deactivated
var button_held: bool = false

var level: LevelManager
var tiles_to_grow_back = 0

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
		level.current_map.snake_tail.snek_shrinking = true
		#uses-1 is the light index for the itembag to go out
		item_activated.emit(uses-1)
	if Input.is_action_just_released(active_item_button) and button_held == true:
		button_held = false
		level.current_map.snake_tail.snek_shrinking = false
		item_deactivated.emit()
		uses -= 1
		SignalBus.continue_moving.emit(active_item_slot.get_parent().current_map.snake_head.current_direction)

func _on_next_tile_reached():
	if button_held:
		if level.current_map.snake_path_bodyparts.size() > 1:
			SignalBus.stop_moving.emit(true)
			tiles_to_grow_back += 1
		else:
			level.current_map.snake_tail.delayed_regrow_tiles(5, tiles_to_grow_back)

func _on_item_deactivated():
	active_item_slot.get_parent().snake_head.moves = true
	level.current_map.snake_tail.delayed_regrow_tiles(5, tiles_to_grow_back)
	tiles_to_grow_back = 0
	

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()

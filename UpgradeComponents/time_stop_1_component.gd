extends ActiveItemBase

signal item_deactivated
var button_held: bool = false
var level:LevelManager
@onready var stop_timer: Timer = $StopTimer

func _ready() -> void:
	super._ready()
	active_item_slot = get_parent()
	level = active_item_slot.get_parent()
	show_behind_parent = true
	item_deactivated.connect(_on_item_deactivated)
	item_activated.connect(active_item_slot._on_item_activated.bind())
	SignalBus.pre_next_tile_reached.connect(_on_next_tile_reached)
	stop_timer.timeout.connect(_force_button_released)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(active_item_button) and uses > 0 and not shop_phase:
		button_held = true
		item_activated.emit(uses-1)
		stop_timer.start()
	if Input.is_action_just_released(active_item_button) and button_held == true:
		button_held = false
		item_deactivated.emit()
		#uses-1 is the light index for the itembag to go out
		uses -= 1
		SignalBus.continue_moving.emit(level.current_map.snake_head.current_direction)
		stop_timer.stop()

func _on_next_tile_reached():
	if button_held:
		SignalBus.stop_moving.emit(false)
		
func _on_item_deactivated():
	active_item_slot.get_parent().snake_head.moves = true

func _force_button_released():
	if button_held:
		button_held = false
		item_deactivated.emit()
		#uses-1 is the light index for the itembag to go out
		uses -= 1
		SignalBus.continue_moving.emit(level.current_map.snake_head.current_direction)
		

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()

extends ActiveItemBase

signal item_deactivated
var button_held: bool = false
var next_tile_reached_emitted_this_frame: bool = false

func _ready() -> void:
	super._ready()
	active_item_slot = get_parent()
	show_behind_parent = true
	item_activated.connect(_on_item_activated)
	item_deactivated.connect(_on_item_deactivated)
	item_activated.connect(active_item_slot._on_item_activated.bind())
	SignalBus.pre_next_tile_reached.connect(_on_next_tile_reached)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(active_item_button) and uses > 0 and not shop_phase:
		button_held = true
	if Input.is_action_just_released(active_item_button):
		button_held = false
		item_deactivated.emit()
		#uses-1 is the light index for the itembag to go out
		uses -= 1
		SignalBus.continue_moving.emit()

func _on_next_tile_reached():
	if button_held:
		item_activated.emit(uses-1)
		print("emited")

func _on_item_activated(_uses):
	SignalBus.stop_moving.emit()

func _on_item_deactivated():
	active_item_slot.get_parent().snake_head.moves = true

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()

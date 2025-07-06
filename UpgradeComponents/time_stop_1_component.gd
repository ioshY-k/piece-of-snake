extends ActiveItemBase

signal item_deactivated
var button_held: bool = false

func _ready() -> void:
	active_item_slot = get_parent()
	show_behind_parent = true
	item_activated.connect(active_item_slot.get_parent()._on_item_activated)
	item_deactivated.connect(active_item_slot.get_parent()._on_item_deactivated)
	item_activated.connect(active_item_slot._on_item_activated.bind())


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(active_item_button) and uses > 0:
		button_held = true
	if Input.is_action_just_released(active_item_button):
		button_held = false
		item_deactivated.emit(GameConsts.UPGRADE_LIST.TIME_STOP_1)
		#uses-1 is the light index for the itembag to go out
		uses -= 1
		SignalBus.continue_moving.emit()
	if button_held:
		item_activated.emit(GameConsts.UPGRADE_LIST.TIME_STOP_1, uses-1)

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()

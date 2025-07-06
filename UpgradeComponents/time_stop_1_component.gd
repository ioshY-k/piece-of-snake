extends Node2D

var uses: int
signal item_activated
signal item_deactivated
var active_item_slot: ActiveItemSlot
var max_uses :int
var button_held: bool = false

func _ready() -> void:
	active_item_slot = get_parent()
	show_behind_parent = true
	item_activated.connect(active_item_slot.get_parent()._on_item_activated)
	item_deactivated.connect(active_item_slot.get_parent()._on_item_deactivated)
	item_activated.connect(active_item_slot._on_item_activated.bind())

func set_uses(use_num: int):
	print("uses set to " + str(use_num))
	max_uses = use_num
	uses = use_num
	for use in range(uses):
		active_item_slot.add_light()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("item1") and uses > 0:
		button_held = true
	if Input.is_action_just_released("item1"):
		button_held = false
		item_deactivated.emit(GameConsts.UPGRADE_LIST.TIME_STOP_1)
		#uses-1 is the light index for the itembag to go out
		uses -= 1
		SignalBus.continue_moving.emit()
	if button_held:
		item_activated.emit(GameConsts.UPGRADE_LIST.TIME_STOP_1, uses-1)
		

func refresh_uses():
	uses = max_uses

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()

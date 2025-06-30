extends Node2D

var uses = 2
signal item_activated
var active_item_slot: ActiveItemSlot

func _ready() -> void:
	active_item_slot = get_parent()
	show_behind_parent = true
	for use in range(uses):
		active_item_slot.add_light()
		
	item_activated.connect(active_item_slot.get_parent()._on_item_activated)
	item_activated.connect(active_item_slot._on_item_activated.bind())

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("item1") and uses > 0:
		#uses-1 is the light index for the itembag to go out
		item_activated.emit(GameConsts.UPGRADE_LIST.FRUIT_RELOCATOR_1, uses-1)
		uses -= 1
		

func refresh_uses():
	uses = 2

func self_destruct():
	queue_free()

extends ActiveItemBase

signal item_deactivated
var button_held: bool = false

const TILE_SELECT_CURSOR = preload("res://UpgradeComponents/WormHole/tile_select_cursor.tscn")
var tile_select_cursor: Sprite2D

var current_teleporters: Array[Teleporter] = []
var current_map

func _ready() -> void:
	super._ready()
	active_item_slot = get_parent()
	show_behind_parent = true
	item_activated.connect(_on_item_activated)
	item_deactivated.connect(_on_item_deactivated)
	item_activated.connect(active_item_slot._on_item_activated.bind())
	SignalBus.teleport_finished.connect(_on_teleport_finished)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed(active_item_button) and uses > 0 and not shop_phase:
		current_map = active_item_slot.get_parent().current_map
		current_map.process_mode = Node.PROCESS_MODE_DISABLED
		button_held = true
		item_activated.emit(uses-1)
		tile_select_cursor = TILE_SELECT_CURSOR.instantiate()
		active_item_slot.get_parent().add_child(tile_select_cursor)
	if Input.is_action_just_released(active_item_button) and button_held:
		button_held = false
		item_deactivated.emit()
		tile_select_cursor.queue_free()
		#uses-1 is the light index for the itembag to go out
		uses -= 1
	if button_held:
		tile_select_cursor.global_position = current_map.to_global( TileHelper.tile_to_position(TileHelper.position_to_tile(current_map.get_local_mouse_position())))
		

func _on_item_activated(_uses):
	active_item_slot.get_parent().time_meter.stop_timer()
	

func _on_item_deactivated():
	var new_teleporter: Teleporter = current_map.spawn_teleporter(tile_select_cursor.global_position)
	current_teleporters.append(new_teleporter)
	current_map.process_mode = Node.PROCESS_MODE_INHERIT
	active_item_slot.get_parent().time_meter.continue_timer()
	
	
func _on_teleport_finished(teleporter: Teleporter):
	for tele in current_teleporters:
		if tele == teleporter:
			current_teleporters.erase(tele)
			teleporter.queue_free()

func self_destruct():
	active_item_slot.remove_lights()
	queue_free()
